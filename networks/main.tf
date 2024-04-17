resource "aws_vpc" "adlab_vpc" {
  cidr_block = "${var.cidr_prefix}.0.0/16"
  tags = {
    Name        = "ADLAB VPC"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "adlab_gw" {
  vpc_id = aws_vpc.adlab_vpc.id
  tags = {
    Name        = "ADLAB Gateway"
    Environment = var.env
  }
}

resource "aws_subnet" "adlab_subnet" {
  vpc_id                  = aws_vpc.adlab_vpc.id
  cidr_block              = "${var.cidr_prefix}.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "ADLAB Subnet"
    Environment = var.env
  }
}

resource "aws_subnet" "blueteam_subnet" {
  vpc_id                  = aws_vpc.adlab_vpc.id
  cidr_block              = "${var.cidr_prefix}.20.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "Blue Team Subnet"
    Environment = var.env
  }
}

resource "aws_subnet" "attacker_subnet" {
  vpc_id                  = aws_vpc.adlab_vpc.id
  cidr_block              = "${var.cidr_prefix}.30.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "Attacker Subnet"
    Environment = var.env
  }
}

resource "aws_route_table" "adlab_route_table" {
  vpc_id = aws_vpc.adlab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.adlab_gw.id
  }

  tags = {
    Name        = "ADLAB Route Table"
    Environment = var.env
  }
}

resource "aws_route_table_association" "adlab_association" {
  subnet_id      = aws_subnet.adlab_subnet.id
  route_table_id = aws_route_table.adlab_route_table.id
}

resource "aws_route_table_association" "blueteam_association" {
  subnet_id      = aws_subnet.blueteam_subnet.id
  route_table_id = aws_route_table.adlab_route_table.id
}

resource "aws_route_table_association" "attacker_association" {
  subnet_id      = aws_subnet.attacker_subnet.id
  route_table_id = aws_route_table.adlab_route_table.id
}
