# provider "aws" {
#   region = "us-east-1"  # Change to your preferred region
# }

# provider "null" {
#   version = "~> 3.0"
# }

resource "aws_ecr_repository" "nexus_repo" {
  name = "nexus-repo"
}

resource "null_resource" "pull_and_push_image" {
  provisioner "local-exec" {
    command = <<EOT
      ./pull_and_push_latest_image.sh ${aws_ecr_repository.nexus_repo.repository_url}
    EOT
  }

  depends_on = [aws_ecr_repository.nexus_repo]
}

output "repository_url" {
  value = aws_ecr_repository.nexus_repo.repository_url
}
