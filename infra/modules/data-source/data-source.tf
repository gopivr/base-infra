resource "aws_db_instance" "postgres" {
  identifier              = "${var.project}-${terraform.workspace}-database"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "17.4"
  instance_class          = "db.t4g.micro"
  db_name                 = var.db_name
  username                = "doyomo"
  password                = "password"
  db_subnet_group_name    = var.public_subnet_group_name
  vpc_security_group_ids  = [var.rds_sg_id, var.ecs_cluster_sg_id]
  publicly_accessible     = true
  skip_final_snapshot     = true
  deletion_protection     = false
  final_snapshot_identifier = "${var.project}-${terraform.workspace}-database-final-snapshot"
  copy_tags_to_snapshot     = true

  tags = {
    Name        = "${var.project}-${terraform.workspace}-rds-db-instance"
    Project     = var.project
    Environment = terraform.workspace
  }
}
