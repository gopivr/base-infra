output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

output "ecs_cluster_sg_id" {
  value = aws_security_group.ecs_cluster_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}