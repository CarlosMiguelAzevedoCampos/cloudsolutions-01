#!/bin/bash
yum update -y
yum install -y python3 python3-pip awscli amazon-cloudwatch-agent
python3 -m pip install --upgrade pip

# Set global environment variable
echo "BUCKET_NAME=${bucket_name}" >> /etc/environment

# Allow ec2-user to run python3 without password
echo "ec2-user ALL=(ALL) NOPASSWD: /usr/bin/python3" >> /etc/sudoers

# Create app directory
mkdir -p /opt/${vpc_name}-app
cd /opt/${vpc_name}-app

aws s3 cp s3://${s3_code_bucket_name}/app.py /opt/${vpc_name}-app/app.py
aws s3 cp s3://${s3_code_bucket_name}/requirements.txt /opt/${vpc_name}-app/requirements.txt

pip3 install -r /opt/${vpc_name}-app/requirements.txt

# Create CloudWatch agent config
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << CWAGENT_EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/${vpc_name}-app.log",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CWAGENT_EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# Create the systemd service for the app
cat > /etc/systemd/system/${vpc_name}-app.service << SERVICE_EOF
[Unit]
Description=Cloud Solutions Python App
After=network.target

[Service]
Environment=BUCKET_NAME=${bucket_name}
WorkingDirectory=/opt/${vpc_name}-app
ExecStart=/usr/bin/sudo /usr/bin/python3 app.py
Restart=always
User=ec2-user

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl daemon-reload
systemctl enable ${vpc_name}-app
systemctl start ${vpc_name}-app
