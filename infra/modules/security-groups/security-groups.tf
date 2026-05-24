resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.project}-${var.env}-vpc-endpoint-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_cluster_sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_cluster_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.env}-vpc-endpoint-sg"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_security_group" "ecs_cluster_sg" {
  name        = "${var.project}-${var.env}-ecs_cluster_sg"
  description = "Security group for ECS cluster in private subnets"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow communication within ECS tasks"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.env}-ecs_cluster_sg"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.env}-alb-sg"
  description = "Allow inbound traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows public access to port 80
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows public access to port 443
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.env}-alb-sg"
    Project     = var.project
    Environment = var.env
  }
}

  resource "aws_security_group" "rds_sg" {
    name        = "${var.project}-${var.env}-rds-sg"
    description = "Security group for RDS instance"
    vpc_id      = var.vpc_id

    ingress {
      description      = "Allow PostgreSQL traffic from ECS tasks"
      from_port        = 5432
      to_port          = 5432
      protocol         = "tcp"
      security_groups  = [aws_security_group.ecs_cluster_sg.id]
    }

    egress {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name        = "${var.project}-${var.env}-rds-sg"
      Project     = var.project
      Environment = var.env
    }
  }