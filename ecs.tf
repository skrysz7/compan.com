module "ecs" {
    source = "./ecs"
    public_subnet1_id   = aws_subnet.public-us-east-1[0].id
    public_subnet2_id   = aws_subnet.public-us-east-1[1].id
}