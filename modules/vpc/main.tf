module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "global-${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs  = ["us-east-1a"] 

  private_subnet_names = ["private1-subnet"]
  private_subnets      = ["10.0.1.0/24"]

  public_subnet_names  = ["public1-subnet"]
  public_subnets       = ["10.0.101.0/24"]

  tags  = var.tags
}