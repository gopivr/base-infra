resource "aws_ecr_repository" "ecr" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  tags = merge(
    {
      Name = var.repo_name
    },
    var.tags
  )
}