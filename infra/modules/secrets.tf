resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project}-${var.env}-db-credentials-v1"
  description = "Database credentials for ${var.project} in ${var.env}"
  recovery_window_in_days = 7

  tags = {
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
