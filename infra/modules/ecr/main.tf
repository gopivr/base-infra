resource "aws_ecr_repository" "ecr" {
  name                 = "${var.repo_name}-${var.env}-repo"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  tags = merge(
    {
      Name = "${var.repo_name}-${var.env}-repo"
    },
    var.tags
  )
}