variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-central-1"
}

variable "db_username" {
  description = "RDS MySQL username"
  type        = string
  default     = "admin"
}

