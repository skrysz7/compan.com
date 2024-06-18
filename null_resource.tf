# # provider "aws" {
# #   region = "us-east-1"  # Change to your preferred region
# # }

# # provider "null" {
# #   version = "~> 3.0"
# # }

# resource "aws_ecr_repository" "nexus_repo" {
#   name = "nexus-repo"
# }

# resource "null_resource" "pull_and_push_image" {
#   provisioner "local-exec" {
#     command = <<EOT
#       #!/bin/bash
#       set -e

#       # Install Docker if not present
#       if ! command -v docker &> /dev/null
#       then
#           echo "Docker not found, installing..."
#           curl -fsSL https://get.docker.com -o get-docker.sh
#           sudo sh get-docker.sh
#           sudo usermod -aG docker $USER
#           newgrp docker
#       fi

#       # Ensure jq is installed
#       if ! command -v jq &> /dev/null
#       then
#           echo "jq not found, installing..."
#           sudo apt-get update
#           sudo apt-get install -y jq
#       fi

#       ECR_URL=${aws_ecr_repository.nexus_repo.repository_url}

#       # Get the latest tag of the nexus3 image from Docker Hub
#       LATEST_TAG=$(curl -s https://hub.docker.com/v2/repositories/sonatype/nexus3/tags/?page_size=1 | jq -r '.results[0].name')

#       echo "Latest tag of sonatype/nexus3: $LATEST_TAG"

#       # Log in to AWS ECR
#       $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL)

#       # Pull the latest image from Docker Hub
#       docker pull sonatype/nexus3:$LATEST_TAG

#       # Tag the image for ECR
#       docker tag sonatype/nexus3:$LATEST_TAG $ECR_URL:latest

#       # Push the image to ECR
#       docker push $ECR_URL:latest

#       echo "Pushed $ECR_URL:latest"
#     EOT
#   }

#   depends_on = [aws_ecr_repository.nexus_repo]
# }

# output "repository_url" {
#   value = aws_ecr_repository.nexus_repo.repository_url
# }
provider "null" {
  # Terraform will automatically download the null provider
}

resource "null_resource" "os_info" {
  provisioner "local-exec" {
    command = "uname -a"
    # Capturing the output in a temporary file
    # and using it in an output variable directly
    # could be done through the `script_output` variable
  }

  triggers = {
    os_info = uuid() # Trigger to ensure the provisioner runs
  }
}

data "external" "os_info" {
  program = ["sh", "-c", "uname -a"]

  # Pass no additional input arguments
  query = {}
}

output "os_info" {
  value = data.external.os_info.result.stdout
}


output "os_info" {
  value = file("os_info.txt")
}
