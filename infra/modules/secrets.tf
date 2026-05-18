resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project}-${terraform.workspace}-db-credentials-v1"
  description = "Database credentials for ${var.project} in ${terraform.workspace}"
  recovery_window_in_days = 7

  tags = {
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
