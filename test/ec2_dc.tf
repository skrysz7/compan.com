resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair"
}

resource "aws_instance" "dc" {
  instance_type        = "t3.medium"
  ami                  = data.aws_ami.dc-compan-com
  depends_on           = [aws_key_pair.tf-key-pair]
  key_name             = "tf-key-pair"
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name

  # ignore all changes made manually
  #   lifecycle {
  #     ignore_changes = all
  #   }
}

resource "aws_iam_instance_profile" "dev-resources-iam-profile" {
  name = "ec2_profile"
  role = aws_iam_role.dev-resources-iam-role.name
}
resource "aws_iam_role" "dev-resources-iam-role" {
  name               = "dev-ssm-role"
  description        = "The role for the developer resources EC2"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
  tags = {
    stack = "test"
  }
}
resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
  role       = aws_iam_role.dev-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_ssm_document" "echo" {
  depends_on    = [aws_instance.dc]
  name          = "echo"
  document_type = "Command"
  content       = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Example SSM document",
  "parameters": {
  },
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "name": "runPowerShellScript",
      "inputs": {
        "runCommand": [
          "New-Item -ItemType Directory 'C:\\test'",
          "$Password = ConvertTo-SecureString -String 'P@ssw0rd' -AsPlainText -Force",
          "New-LocalUser -Name 'tempadminuser' -Password $Password",
          "Add-LocalGroupMember -Group 'Administrators' -Member 'tempadminuser'",
          "Set-LocalUser -Name 'tempadminuser' -PasswordNeverExpires 1"
        ]
      }
    }
  ]
}
DOC
}

resource "aws_ssm_association" "example" {
  name = aws_ssm_document.echo.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.dc.id]
  }
}

# resource "aws_instance" "ec2" {
#   ami = data.aws_ami.win2022.id
#   for_each = {
#     EC2_1 = "t2.micro"
#     EC2_2 = "t2.medium"
#   }
#   instance_type = each.value
#   key_name = each.key
#   tags = {
#     Name = each.key
#   }
# }


# resource "aws_instance" "websrv" {
#   ami = data.aws_ami.win2022.id
#   instance_type = "t3.medium"
#   key_name = "terraform"

#   provisioner "remove-exec" {
#     inline = [
#         "sudo amazon-linux-extras install -y nginx1.12",
#         "sudo systemctil start nginx"
#     ]

#     connection {
#       type = "ssh"
#       host = self.public_ip
#       user = "ec2-user"
#       private_key = "${file("./terraform.pem")}"
#     }
#   }
# }



