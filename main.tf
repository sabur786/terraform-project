
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }
}

variable "prd_enable_dns_hostnames" {
  description = "Enable DNS hostnames for the production VPC"
  type        = bool
  default     = true
}

#Resource: aws-vpc.prd-vpc 
# 
resource "aws_vpc" "prd-vpc" {
  cidr_block           = var.prd_vpc_cidr_block
  enable_dns_hostnames = var.prd_enable_dns_hostnames

}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.dev_cidr_block
  vpc_name       = var.dev_vpc_name
}

resource "aws_security_group" "dev-web-sg" {
  
  vpc_id = module.vpc.vpc_id

  ingress {
    description = " allow HTTP inbound traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    }
}  

resource "aws_subnet" "prd-pub-subnet-1" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prd-pub-subnet-1"
  }
}
resource "aws_subnet" "prd-pub-subnet-2" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prd-pub-subnet-2"
  }
}

resource "aws_subnet" "prd-pub-subnet-3" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "prd-pub-subnet-3"
  }
}
resource "aws_subnet" "prd-priv-subnet-1" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prd-priv-subnet-1"
  }
}
resource "aws_subnet" "prd-priv-subnet-2" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "prd-priv-subnet-2"
  }
}
resource "aws_subnet" "prd-priv-subnet-3" {
  vpc_id            = aws_vpc.prd-vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "prd-priv-subnet-3"
  }
}

resource "aws_internet_gateway" "prd-igw" {
  vpc_id = aws_vpc.prd-vpc.id

  tags = {
    Name = "prd-igw"
  }
}
resource "aws_route_table" "prd-pub-rt" {
  vpc_id = aws_vpc.prd-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prd-igw.id
  }
  tags = {
    Name = "prd-pub-rt"
  }
}

resource "aws_route_table_association" "prd-pub-rt-assoc-1" {
  subnet_id      = aws_subnet.prd-pub-subnet-1.id
  route_table_id = aws_route_table.prd-pub-rt.id
}
resource "aws_route_table_association" "prd-pub-rt-assoc-2" {
  subnet_id      = aws_subnet.prd-pub-subnet-2.id
  route_table_id = aws_route_table.prd-pub-rt.id
}
resource "aws_route_table_association" "prd-pub-rt-assoc-3" {
  subnet_id      = aws_subnet.prd-pub-subnet-3.id
  route_table_id = aws_route_table.prd-pub-rt.id
}
resource "aws_route_table" "prd-priv-rt" {
  vpc_id = aws_vpc.prd-vpc.id

  tags = {
    Name = "prd-priv-rt"
  }
}
resource "aws_route_table_association" "prd-priv-rt-assoc-1" {
  subnet_id      = aws_subnet.prd-priv-subnet-1.id
  route_table_id = aws_route_table.prd-priv-rt.id
}
resource "aws_route_table_association" "prd-priv-rt-assoc-2" {
  subnet_id      = aws_subnet.prd-priv-subnet-2.id
  route_table_id = aws_route_table.prd-priv-rt.id
}
resource "aws_route_table_association" "prd-priv-rt-assoc-3" {
  subnet_id      = aws_subnet.prd-priv-subnet-3.id
  route_table_id = aws_route_table.prd-priv-rt.id
}
