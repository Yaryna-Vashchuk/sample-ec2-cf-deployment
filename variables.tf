variable "region" {
    default = "us-east-1"
}

variable "project_name" {
    default = "myproject"
}

variable "environment" {
    default = "stage" # options: stage, prod
}

variable "domain_name" {
    default = "domain.com"
}

variable "hosted_zone_id" {
    default = "Z123456ABCDEFG" # Replace with an actual Hosted Zone ID
}