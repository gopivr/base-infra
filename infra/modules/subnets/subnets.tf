resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.selected.names)

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = data.aws_availability_zones.selected.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${terraform.workspace}-public-${count.index}"
    Project     = var.project
    Environment = terraform.workspace
    Type        = "public"
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-${terraform.workspace}-public-table"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_igw.id
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count = length(aws_subnet.public_subnet)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "${var.project}-${terraform.workspace}-public-subnet-group"
  description = "Public subnet group"
  subnet_ids = aws_subnet.public_subnet[*].id

  tags = {
    Name        = "${var.project}-${terraform.workspace}-public-subnet-group"
    Project     = var.project
    Environment = terraform.workspace
    Type        = "public"
  }
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-${terraform.workspace}-internet-gateway"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(data.aws_availability_zones.selected.names)

  vpc_id            = var.vpc_id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + length(data.aws_availability_zones.selected.names))
  availability_zone = data.aws_availability_zones.selected.names[count.index]

  tags = {
    Name        = "${var.project}-${terraform.workspace}-private-${count.index}"
    Project     = var.project
    Environment = terraform.workspace
    Type        = "private"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-${terraform.workspace}-private-table"
    Project     = var.project
    Environment = terraform.workspace
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count = length(aws_subnet.private_subnet)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "${var.project}-${terraform.workspace}-private-subnet-group"
  description = "Private subnet group"
  subnet_ids = aws_subnet.private_subnet[*].id

  tags = {
    Name        = "${var.project}-${terraform.workspace}-private-subnet-group"
    Project     = var.project
    Environment = terraform.workspace
    Type        = "private"
  }
}