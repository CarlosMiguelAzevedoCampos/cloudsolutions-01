resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.vpc_name}-ecs-cluster"
  tags = var.common_tags
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/aws/ecs/${var.vpc_name}-app-01"
  retention_in_days = 0
  tags              = var.common_tags
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.vpc_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.vpc_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_policy" "ecs_task_s3_put_policy" {
  name        = "${var.vpc_name}-ecs-s3-put-policy"
  description = "Allow ECS tasks to PUT objects into the S3 bucket."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject"],
        Resource = ["arn:aws:s3:::${var.s3_data_bucket_name}/*"]
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_put_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_s3_put_policy.arn
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.vpc_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "${var.vpc_name}-container"
      image = var.container_image
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "BUCKET_NAME"
          value = var.s3_data_bucket_name
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.common_tags
}

# 9. Create ECS Service (needs ECS Cluster + Task Definition)
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.vpc_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.vpc_name}-container"
    container_port   = var.container_port
  }

  depends_on = [
    aws_iam_role.ecs_execution_role,
    aws_iam_role.ecs_task_role
  ]

  tags = var.common_tags
}

# 10. Create App AutoScaling Target (depends on ECS Service)
resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.maximum_count
  min_capacity       = var.minimum_count
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.ecs_service
  ]
}

# 11. Create App AutoScaling Policies (depends on AutoScaling Target)
resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "${var.vpc_name}-scale-up-01"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }

    cooldown = var.scale_up_cooldown
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "${var.vpc_name}-scale-down-01"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }

    cooldown = var.scale_down_cooldown
  }
}
