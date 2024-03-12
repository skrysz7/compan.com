module "ecs" {
    source = "./ecs"
    public_subnet1_id   = element(aws_subnet.public-us-east-1[*].id, 0)
    public_subnet2_id   = element(aws_subnet.public-us-east-1[*].id, 1)
}