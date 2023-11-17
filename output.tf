output "vpc_id" {
  value = aws_vpc.vpc-us-east-1.id
}

output "subnet_id_private" {
  value = aws_subnet.private-us-east-1[*].id
}

output "subnet_id_public" {
  value = aws_subnet.public-us-east-1[*].id
}

//comment
/*comment
comment*/

# output "public-ip" {
#   value = "https://${aws_eip.lb.public_ip}:8080"
# }