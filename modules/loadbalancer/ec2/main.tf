resource "aws_lb" "ec2_alb" {
  name               = "${var.vpc_name}-ec2-alb-01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpc_name}-ec2-alb-01"
    }
  )
}

resource "aws_lb_target_group" "ec2_target_group" {
  name        = "${var.vpc_name}-ec2-tg-01"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.vpc_name}-ec2-target-group-01"
    }
  )
}

resource "aws_lb_listener" "ec2_listener" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }
}