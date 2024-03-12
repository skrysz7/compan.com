module "ecs" {
    source = "./ecs"
    public_subnet_a_id = var.public_subnet_names
    # public_subnet_b_id = element(aws_subnet.public-us-east-1[*].id, 1)
}