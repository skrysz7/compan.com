resource "aws_kms_key" "key" {
  description             = "KMS key to encrypt and decrypt EC2 instances and EBS volumes"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  tags                    = merge(local.tags-general, { default-key = true })

  policy = <<POLICY
 {
        "Version": "2012-10-17",
        "Id": "key-default-1",
        "Statement": [
            {
                "Sid": "Enable IAM User Permissions",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                },
                "Action": "kms:*",
                "Resource": "*"
            }]
    } 
    POLICY
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/compan-kms-key"
  target_key_id = aws_kms_key.key.key_id
}