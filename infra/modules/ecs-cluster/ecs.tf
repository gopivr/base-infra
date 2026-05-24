resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.env}-cluster"

  tags = {
    Name        = "${var.project}-${var.env}-ecs-cluster"
    Project     = var.project
    Environment = var.env
  }
}