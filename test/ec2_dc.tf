resource "aws_instance" "dc" {
  instance_type = "t3.medium"
  ami           = data.aws_ami.win2022.id



# ignore all changes made manually
#   lifecycle {
#     ignore_changes = all
#   }
}

resource "aws_ssm_document" "echo" {
  name          = "echo"
  document_type = "Command"
  content       = <<DOC
{
    "schemaVersion": "1.2",
    "description": "Add 'Hello' to c:\hello.txt.",
    "parameters": {
    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": ["echo \"Hello!\" > c:\hello.txt"]
          }
        ]
      }
    }
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



