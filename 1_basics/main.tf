terraform {
  # Mention which providers we want.
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 3.0"
    }
  }
}

# Mention default region for that provider.
provider "aws" {
  region = "us-east-1"
}


# Corresponds to an `instance` within "EC2"
resource "aws_instance" "example" {
  # ami :: Amazon Machine Image === Full set of info required to create an EC2 virtual machine instance.
  ami           = "ami-011899242bb902164" # Means ::> `Ubuntu 20.04 LTS - us-east-1`
  instance_type = "t2.micro"
}
