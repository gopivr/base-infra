resource "time_sleep" "wait_for_alb_cleanup" {
  depends_on = [
    aws_lb.public_alb
  ]

  destroy_duration = "180s"
}

resource "aws_lb" "public_alb" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name        = "${var.project}-${var.env}-alb"
    Project     = var.project
    Environment = var.env
  }
}
