resource "aws_iam_policy" "ecr_pullthroughcache_policy" {
  name        = "${var.project}-${var.env}-ecr-pullthrough-policy"
  description = "Policy to allow ECS task execution role to interact with ECR pull-through cache"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeImages"
        ],
        Resource = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      }
    ]
  })

  tags = {
    Name        = "${var.project}-${var.env}-ecr-pullthrough-policy"
    Project     = var.project
    Environment = var.env
  }
}

# resource "aws_iam_policy" "secrets_manager_policy" {
#   name        = "${var.project}-${var.env}-secrets-manager-policy"
#   description = "Policy to allow ECS task execution role to access Secrets Manager secrets"
#   policy      = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ],
#         "Resource": [
#           aws_secretsmanager_secret.db_credentials.arn,
#         ]
#       }
#     ]
#   })

#   tags = {
#     Name        = "${var.project}-${var.env}-secrets-manager-policy"
#     Project     = var.project
#     Environment = var.env
#   }
# }

# resource "aws_iam_role_policy" "app_autoscaling_policy" {
#   name = "${var.project}-${var.env}-app-autoscaling-policy"
#   role = aws_iam_role.appAutoscalingRole.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ecs:UpdateService",
#           "ecs:DescribeServices",
#           "cloudwatch:DescribeAlarms",
#           "cloudwatch:GetMetricData",
#           "cloudwatch:PutMetricAlarm",
#           "cloudwatch:DeleteAlarms"
#         ]
#         Resource = "*"
#       },
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionPolicy_AmazonEC2ContainerServiceforEC2Role" {
  role        = var.ecs_task_execution_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionPolicy_AmazonECSTaskExecutionRolePolicy" {
  role        = var.ecs_task_execution_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionPolicy_AWSServiceRoleForECRPullThroughCache" {
  role       = var.ecs_task_execution_role_name
  policy_arn = aws_iam_policy.ecr_pullthroughcache_policy.arn
}