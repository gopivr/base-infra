# Public Subnets
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_subnet_route_table.id
}

# Internet Gateway
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.public_igw.id
}

# Private Subnets
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_subnet_route_table.id
}

output "private_db_subnet_group_name" {
  description = "Name of the private DB subnet group"
  value       = aws_db_subnet_group.private_subnet_group.name
}
