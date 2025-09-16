output "public_subnet_ids" {
  # replaced incorrect reference aws_subnet.public.*.id with actual public subnet resources
    value = [
    aws_subnet.prd-pub-subnet-1.id,
    aws_subnet.prd-pub-subnet-2.id,
    aws_subnet.prd-pub-subnet-3.id,
  ]
  
}

output "vpc_id" {
  # replaced incorrect reference aws_vpc.main.id with actual VPC resource name
  value = aws_vpc.prd-vpc.id
}

