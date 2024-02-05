# General variables
variable "environment_name" {
  description = "Deployment Environment (dev/staging/production)"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Name of web application"
  type        = string
  default     = "web-app"
}

variable "region" {
  description = "Default region for provider"
  type        = string
  default     = "us-east-1"
}

# S3 bucket
variable "bucket_prefix" {
  description = "Prefix of S3 bucket for app data"
  type        = string
}

# Instances(EC2) Variables
variable "ami" {
  description = "Amazon Machine Image to use for EC2"
  type        = string
  default     = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

# DB variables
variable "db_user" {
  description = "Username of the Database"
  type        = string
}

variable "db_pass" {
  description = "Password of the Database"
  type        = string
  sensitive   = true
}

# Route 53 variables

variable "create_dns_zone" {
  description = "If TRUE create new route53 zone, if FALSE read existing route53 zone"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Route 53 domain"
  type        = string
}
