resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
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
  instance_type = "t3.medium"
  ami           = data.aws_ami.win2022.id
  key_name      = "tf-key-pair"

# ignore all changes made manually
#   lifecycle {
#     ignore_changes = all
#   }
}

resource "aws_ssm_document" "echo" {
  depends_on = [aws_instance.dc]
  name          = "echo"
  document_type = "Command"
  content       = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Example SSM document",
  "parameters": {
    "BucketName": {
      "type": "String",
      "description": "The name of the S3 bucket where the PowerShell script is stored."
    }
  },
  "mainSteps": [
    {
      "action": "aws:runPowerShellScript",
      "name": "runPowerShellScript",
      "inputs": {
        "runCommand": [
          "Write-Host 'Running PowerShell script'",
          "new-item -ItemType Directory C:\test"
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



