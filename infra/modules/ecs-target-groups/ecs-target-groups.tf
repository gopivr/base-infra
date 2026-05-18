resource "aws_lb_target_group" "ecs_target_group" {
  name        = "${var.project}-${terraform.workspace}-ecs-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
    protocol            = "HTTP"
  }

  tags = {
    Name        = "${var.project}.${terraform.workspace}-ecs-tg"
    Project     = var.project
    Environment = terraform.workspace
  }
} 

resource "aws_cloudwatch_log_group" "ecs-log-group" {
  name              = "ecs-log-group"
  retention_in_days = 1
}