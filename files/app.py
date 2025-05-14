from flask import Flask, request, redirect, render_template_string, url_for
import boto3
import os
import logging
from datetime import datetime

# Set up logging
LOG_FILE = '/var/log/cloudsolutions-app.log'
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)  # Ensure the log directory exists

logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s',
)

app = Flask(__name__)

BUCKET_NAME = os.getenv("BUCKET_NAME", "my-bucket-01")

s3 = boto3.client('s3')

form_template = '''
    <form method="post">
        Enter text: <input type="text" name="text_input">
        <input type="submit">
    </form>
    {% if error %}
    <div style="color: red;">Error: {{ error }}</div>
    {% endif %}
    {% if success %}
    <div style="color: green;">{{ success }}</div>
    {% endif %}
'''

@app.route('/', methods=['GET', 'POST'])
def index():
    error = None
    success = request.args.get('success')

    if request.method == 'POST':
        text_input = request.form.get('text_input', '')
        timestamp = datetime.utcnow().strftime('%Y%m%d_%H%M%S')
        key = f"submission_{timestamp}.txt"
        try:
            s3.put_object(Bucket=BUCKET_NAME, Key=key, Body=text_input)
            logging.info(f"Successfully uploaded '{key}' to bucket '{BUCKET_NAME}' with content: {text_input}")
            return redirect(url_for('index', success="Successfully submitted!"))
        except Exception as e:
            error = str(e)
            logging.error(f"Failed to upload '{key}' to bucket '{BUCKET_NAME}': {error}")

    return render_template_string(form_template, error=error, success=success)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
