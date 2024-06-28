# Terraform AWS Infrastructure Deployment

This repository contains Terraform configurations to deploy a scalable web application infrastructure on AWS. The setup includes a VPC, subnets, security groups, IAM roles, an auto-scaling group of EC2 instances, and an application load balancer.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v0.13 or later
- AWS Programmatic Access
- An SSH key pair for accessing EC2 instances

## Project Structure

- `main.tf`: Contains the provider configuration.
- `network.tf`: Defines the VPC, subnets, internet gateway, and route tables.
- `security.tf`: Defines the security group and IAM roles.
- `compute.tf`: Defines the launch template, auto-scaling group, and load balancer.
- `variables.tf`: Defines the variables used in the configuration.
- `outputs.tf`: Defines the outputs of the configuration.
- `user_data.sh`: User data script for initializing the EC2 instances.
