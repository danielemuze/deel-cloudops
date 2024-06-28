variable "vpc_id" {
  description = "The VPC ID where the resources will be created."
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs."
}

variable "security_group_id" {
  description = "The security group ID to assign to the instances."
}
