resource "aws_iam_role" "ecsTaskExecutionRole" {
  name                = "${var.project}-${terraform.workspace}-execution-task-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "${var.project}-${terraform.workspace}-iam-ecsTaskExecutionRole-role"
    Project     = var.project
    Environment = terraform.workspace
  }
}
