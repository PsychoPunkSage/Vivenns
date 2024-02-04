# Region
variable "region" {
  description = "Region of the Provider"
  type        = string
  default     = "us-east-1"
}

# EC2 variables
variable "ami" {
  description = "Amazon machine image to use for EC2 isntance"
  type        = string
  default     = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# S3 variables
variable "bucket_prefix" {
  description = "prefix of s3 bucket for app data"
  type        = string
}

# Route S3 variables
variable "domain" {
  description = "Domain of the website"
  type        = string
}

# RDS Variables

variable "db_name" {
  description = "name of db"
  type        = string
}

variable "db_user" {
  description = "Username for the db"
  type        = string
}

variable "db_pass" {
  description = "Password for the db"
  type        = string
  sensitive   = true
}
