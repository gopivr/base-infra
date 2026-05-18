resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${terraform.workspace}-cluster"

  tags = {
    Name        = "${var.project}-${terraform.workspace}-ecs-cluster"
    Project     = var.project
    Environment = terraform.workspace
  }
}