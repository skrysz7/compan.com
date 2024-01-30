resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vpc_endpoint_sg.id]
  subnets            = [aws_subnet.private-us-east-1]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.nlb_access_logs.id
    # prefix  = "test-lb"
    enabled = true
  }
}

resource "aws_s3_bucket" "nlb_access_logs" {
  bucket = "xms-sspr-prod-ext-nlb-access-logs"
}

resource "aws_s3_bucket_policy" "allow_access_from_nlb" {
  bucket = aws_s3_bucket.nlb_access_logs.id
  policy = data.aws_iam_policy_document.allow_access_from_nlb.json
}

resource "aws_s3_object" "prefix" {
  bucket = aws_s3_bucket.nlb_access_logs.id
  key    = "prefix"
#   source = "path/to/file"
}

resource "aws_s3_object" "AWSLogs" {
  bucket = aws_s3_bucket.nlb_access_logs.id
  key    = "prefix/AWSLogs"
#   source = "path/to/file"
}

resource "aws_s3_object" "342023131128" {
  bucket = aws_s3_bucket.nlb_access_logs.id
  key    = "prefix/AWSLogs/342023131128"
#   source = "path/to/file"
}

data "aws_iam_policy_document" "allow_access_from_nlb" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::xms-sspr-prod-ext-nlb-access-logs/prefix/AWSLogs/186235423003/*"
    ]
  }
}