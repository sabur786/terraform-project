# This Terraform configuration file creates a VPC and associated resources.

# q: What is a VPC?
# a: A VPC (Virtual Private Cloud) is a virtual network dedicated to your AWS account. It is logically isolated from other virtual networks in the AWS Cloud.

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
    }
}