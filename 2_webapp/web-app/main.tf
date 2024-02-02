terraform {
  # Assumes `s3 bucket` and `dynamo DB table` already exists + setup
  # see >> aws-backend
  backend "s3" {
    bucket         = "devops-directive-tf-state"
    key            = "2_webapp/web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance_1" {
  ami             = "ami-011899242bb902164" # Means ::> `Ubuntu 20.04 LTS - us-east-1`
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name] # Enable `inbound` traffic.
  user_data       = <<-EOF
  #!/bin/bash
  echo "Hello, Everyone. PsychoPunkSage is here" > index.html
  python3 -m http.server 8080
  EOF
}

# To have multiple replicas of our web-app running
resource "aws_instance" "instance_2" {
  ami             = "ami-011899242bb902164" # Means ::> `Ubuntu 20.04 LTS - us-east-1`
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
  #!/bin/bash
  echo "Hello, Everyone. Abhinav is here" > index.html
  python3 -m http.server 8080
  EOF
}

# For big data management
resource "aws_s3_bucket" "bucket" {
  bucket        = "devops-directive-web-app-data"
  force_destroy = true
  # Tobe checked
}

# "data" -> Reference existing resource within AWS.
data "aws_vpc" "default_vps" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vps.id
}

# Defined `Security Groups` to allow inbound traffic.
resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

# Attaching Rules to Security Groups.
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "igress"
  security_group_id = aws_security_group.instances.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
