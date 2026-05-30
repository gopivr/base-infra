resource "aws_db_instance" "postgres" {
  identifier              = "${var.project}-${var.env}-database"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17.4"
  instance_class          = "db.t4g.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = var.public_subnet_group_name
  vpc_security_group_ids  = [var.rds_sg_id, var.ecs_cluster_sg_id]
  publicly_accessible     = true
  skip_final_snapshot     = true
  deletion_protection     = false
  final_snapshot_identifier = "${var.project}-${var.env}-database-final-snapshot"
  copy_tags_to_snapshot     = true

  tags = {
    Name        = "${var.project}-${var.env}-rds-db-instance"
    Project     = var.project
    Environment = var.env
  }

}
