variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 (us-east-1)"
  
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "vprofile-key"
}

variable "db_username" {
  description = "Database master username"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  sensitive   = true
}

variable "rmq_username" {
  description = "RabbitMQ username"
  sensitive   = true
}

variable "rmq_password" {
  description = "RabbitMQ password"
  sensitive   = true
}
