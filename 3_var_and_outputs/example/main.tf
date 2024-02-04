terraform {
  backend "s3" {
    bucket         = "devops-directive-tf-state"
    key            = "3_var_and_outputs/examples/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lockings"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  extra_tag = "extra-tag"
}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name      = var.instance_name
    ExtrraTag = local.extra_tag
  }
}
