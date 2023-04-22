resource "aws_vpc" "default_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "pluma_software_vpc"
  }
}

resource "aws_internet_gateway" "fargate_igw" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "FargateInternetGateway"
  }
}

resource "aws_route_table" "fargate_route_table" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fargate_igw.id
  }

  tags = {
    Name = "FargateRouteTable"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  tags = {
    "Name" = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "fargate_route_table_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.fargate_route_table.id
}

###
### SECURITY GROUP CONFIGURATION
###
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "allow_all_in" {
  security_group_id = aws_security_group.allow_all.id

  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_out" {
  security_group_id = aws_security_group.allow_all.id

  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
