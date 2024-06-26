# #https NLB and TG attachments for external usage


# # resource "aws_lb_target_group_attachment" "port443_to_pet_linux_aw-siam033p_attachment" {
# #   target_group_arn = module.https_iam_prod_ext_nlb.target_group_arns[0]
# #   target_id        = module.siam033p.instance_id
# #   port             = 443
# # }

# # resource "aws_lb_target_group_attachment" "port443_to_pet_linux_aw-siam034p_attachment" {
# #   target_group_arn = module.https_iam_prod_ext_nlb.target_group_arns[0]
# #   target_id        = module.siam034p.instance_id
# #   port             = 443
# # }

# # resource "aws_lb_target_group_attachment" "port9443_to_pet_linux_aw-siam033p_attachment" {
# #   target_group_arn = module.https_iam_prod_ext_nlb.target_group_arns[0]
# #   target_id        = module.siam033p.instance_id
# #   port             = 9443
# # }

# # resource "aws_lb_target_group_attachment" "port9443_to_pet_linux_aw-siam034p_attachment" {
# #   target_group_arn = module.https_iam_prod_ext_nlb.target_group_arns[0]
# #   target_id        = module.siam034p.instance_id
# #   port             = 9443
# # }

# module "https_iam_prod_ext_nlb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "8.2.1"

#   name = "xms-aws-iam-prod-ext-https-nlb"

#   load_balancer_type = "network"

#   vpc_id      = aws_vpc.vpc-us-east-1.id
#   enable_cross_zone_load_balancing = false
#   internal                         = true
#   subnets            = [element(aws_subnet.private-us-east-1[*].id, 0), element(aws_subnet.private-us-east-1[*].id, 1)]
# # subnet mapping wants to recreate ALB
# #   subnet_mapping = [{
# #     subnet_id            = aws_subnet.private-us-east-1[0].id
# #     private_ipv4_address = "10.0.3.226"
# #     },
# #     {
# #     subnet_id            = aws_subnet.private-us-east-1[1].id
# #     private_ipv4_address = "10.0.4.181"
# #     }
# #   ]
# }
# output "module" {
#     value = module.https_iam_prod_ext_nlb
# }
# output "lb_arn_suffix" {
#     value = module.https_iam_prod_ext_nlb.lb_arn_suffix
#     #lb_arn_suffix : "net/xms-aws-iam-prod-ext-https-nlb/84de4c11f1763270"
# }

# data "aws_network_interface" "eni_1a" {
#   filter {
#     name   = "description"
#     values = ["ELB ${module.https_iam_prod_ext_nlb.lb_arn_suffix}"]
#     #ELB net/xms-aws-iam-prod-ext-https-nlb/84de4c11f1763270
#   }
#   filter {
#     name   = "subnet-id"
#     values = [aws_subnet.private-us-east-1[0].id]
#   }
# }

# data "aws_network_interface" "eni_1b" {
#   filter {
#     name   = "description"
#     values = ["ELB ${module.https_iam_prod_ext_nlb.lb_arn_suffix}"]
#   }
#   filter {
#     name   = "subnet-id"
#     values = [aws_subnet.private-us-east-1[1].id]
#   }
# }
# output "eni_id_1a" {
#   value = data.aws_network_interface.eni_1a.id
# }

# output "eni_id_1b" {
#   value = data.aws_network_interface.eni_1b.id
# }

# resource "aws_flow_log" "nlb_flow_logs_1a" {
#   log_destination      = aws_s3_bucket.nlb_access_logs.arn
#   log_destination_type = "s3"
#   traffic_type         = "ALL"
#   eni_id               = data.aws_network_interface.eni_1a.id
# }

# resource "aws_flow_log" "nlb_flow_logs_1b" {
#   log_destination      = aws_s3_bucket.nlb_access_logs.arn
#   log_destination_type = "s3"
#   traffic_type         = "ALL"
#   eni_id               = data.aws_network_interface.eni_1b.id
# }

# resource "aws_s3_bucket" "nlb_access_logs" {
#   bucket = "nlb-fl-test"
#   tags = local.tags-general
# }
# # module "https_iam_prod_ext_nlb" {
# #   source = "path/to/terraform-aws-alb"
# #   # ... other module configurations ...
# # }
# # data "aws_route53_record" "nlb" {
# #   name = module.https_iam_prod_ext_nlb.dns_name
# # }
# # output "nlb_ip" {
# #   value = data.aws_route53_record.nlb.records[0]
# # }
# # output "id" {
# #   description = "The ID and ARN of the load balancer we created"
# #   value       = module.https_iam_prod_ext_nlb.lb_id
# # }


# # data "aws_lb" "sspr_nlb" {
# #   arn = module.https_iam_prod_ext_nlb.load_balancer_arn
# # }



# # resource "aws_flow_log" "nlb_flow_logs_1a" {
# #   log_destination      = aws_s3_bucket.nlb_access_logs.arn
# #   log_destination_type = "s3"
# #   traffic_type         = "ALL"
# #   eni_id               = data.aws_lb.sspr_nlb.network_interfaces[0]
# # }

# # resource "aws_flow_log" "nlb_flow_logs_1b" {
# #   log_destination      = aws_s3_bucket.nlb_access_logs.arn
# #   log_destination_type = "s3"
# #   traffic_type         = "ALL"
# #   eni_id               = data.aws_lb.sspr_nlb.network_interfaces[1]
# # }

# # resource "aws_s3_bucket" "nlb_access_logs" {
# #   bucket = "xms-sspr-prod-nlb-access-logs"
# #   tags = local.tags-general
# # }

# # resource "aws_s3_object" "AWSLogs" {
# #   bucket = aws_s3_bucket.nlb_access_logs.id
# #    key    = "AWSLogs/${data.aws_caller_identity.current.account_id}/"
# # }

# # resource "aws_s3_bucket_policy" "allow_access_from_nlb" {
# #   bucket = aws_s3_bucket.nlb_access_logs.id
# #   policy = data.aws_iam_policy_document.allow_access_from_nlb.json
# # }
# # data "aws_iam_policy_document" "allow_access_from_nlb" {
# #   statement {
# #     sid = "AWSLogDeliveryAclCheck"
# #     effect = "Allow"
# #     principals {
# #       type        = "Service"
# #       identifiers = ["delivery.logs.amazonaws.com"]
# #     }
# #     actions = ["s3:GetBucketAcl"]
# #     resources = ["arn:aws:s3:::xms-sspr-prod-nlb-access-logs"]
# #     condition {
# #       test     = "ForAnyValue:StringEquals"
# #       variable = "aws:SourceAccount"
# #       values   = ["${data.aws_caller_identity.current.account_id}"]
# #     }
# #     condition {
# #       test     = "ForAnyValue:ArnLike"
# #       variable = "aws:SourceArn"
# #       values   = ["arn:aws:logs:eu-north-1:${data.aws_caller_identity.current.account_id}:*"]
# #     }
# #   }
# #   statement {
# #     sid = "AWSLogDeliveryWrite"
# #     effect = "Allow"
# #     principals {
# #       type        = "Service"
# #       identifiers = ["delivery.logs.amazonaws.com"]
# #     }
# #     actions = ["s3:PutObject"]
# #     resources = ["arn:aws:s3:::test-for-alb-sspr/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
# #     condition {
# #       test     = "ForAnyValue:StringEquals"
# #       variable = "aws:SourceAccount"
# #       values   = ["${data.aws_caller_identity.current.account_id}"]
# #     }
# #     condition {
# #       test     = "ForAnyValue:ArnLike"
# #       variable = "aws:SourceArn"
# #       values   = ["arn:aws:logs:eu-north-1:${data.aws_caller_identity.current.account_id}:*"]
# #     }
# #   }
# # }