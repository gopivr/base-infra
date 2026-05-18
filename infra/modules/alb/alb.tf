resource "aws_lb" "public_alb" {
  name               = "${var.project}-${terraform.workspace}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "${var.project}-${terraform.workspace}-alb"
    Project     = var.project
    Environment = terraform.workspace
  }
}
