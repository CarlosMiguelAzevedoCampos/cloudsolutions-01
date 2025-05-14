resource "aws_iam_role" "ec2_role" {
  name = "${var.vpc_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.vpc_name}-ec2-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_code_bucket_name}/*",
          "arn:aws:s3:::${var.s3_data_saving_bucket_name}/*"
        ]
      },
      {
        Sid    = "CloudWatchLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.vpc_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ec2/${var.vpc_name}-app-01"
  retention_in_days = 0
  tags              = var.common_tags
}

data "template_file" "ec2_user_data" {
  template = file("${path.module}/${var.vpc_name}-app-userdata.sh")

  vars = {
    bucket_name         = var.s3_data_saving_bucket_name
    s3_code_bucket_name = var.s3_code_bucket_name
    log_group_name      = aws_cloudwatch_log_group.app_logs.name
    vpc_name            = var.vpc_name
  }
}

# 6. Create Launch Template
resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.vpc_name}-app-lt-01"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(data.template_file.ec2_user_data.rendered)

  network_interfaces {
    security_groups             = [var.app_sg_id]
    associate_public_ip_address = false
    subnet_id                   = null
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpc_name}-launch-template-01"
    }
  )
}

resource "aws_autoscaling_group" "auto_scaling_group" {
  name                      = "${var.vpc_name}-asg-01"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-autoscaling-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.vpc_name}-scale-up-01"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_up_cooldown
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.vpc_name}-scale-down-01"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.scale_down_cooldown
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.name
}
