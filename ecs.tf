module "ecs" {
    source = "./ecs"
    public_subnet1_id   = element(aws_subnet.public-us-east-1[*].id, 0)
    public_subnet2_id   = element(aws_subnet.public-us-east-1[*].id, 1)
    private_subnet1_id  = element(aws_subnet.private-us-east-1[*].id, 0)
    private_subnet2_id  = element(aws_subnet.private-us-east-1[*].id, 1)
    vpc_id              = aws_vpc.vpc-us-east-1.id
}