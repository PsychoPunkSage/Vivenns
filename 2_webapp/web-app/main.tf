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
  cidr_blocks       = ["0.0.0.0/0"] # Allowing all IP addresses
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# Set-up target gropt to specify where to send the traffic.
resource "aws_lb_target_group" "instances" {
  name     = "example-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_2
  port             = 8080
}

resource "aws_lb_listener_rule" "instance" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}

# Different security groups for `load_balancer`
resource "aws_security_group" "alb" {
  name = "alb-security-group"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_http_outbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
  name               = "web-app-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_subnet.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_route53_zone" "primary" {
  name = "helloabhinav.com"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "helloabhinav.com"
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}

# Database
resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "standard"
  engine              = "postgres"
  engine_version      = "12.5"
  instance_class      = "db.t2.micro"
  username            = "foo"
  password            = "foobarbaz"
  skip_final_snapshot = true
}
