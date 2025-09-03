provider "aws" {
  region = var.region
}

locals {
  tags = {
    terraform   = "1"
    environment = var.environment
  }
}

module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  
  tags = local.tags
}

module "sg" {
  source = "./modules/sg"
  
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  environment = var.environment

  tags = local.tags
}


module "ec2" {
  source = "./modules/ec2"

  subnets = [
    module.vpc.public_subnets[0]
  ]
  ec2_security_group_id = module.sg.ec2_security_group_id

  project_name = var.project_name

  tags = local.tags
}

module "rds" {
  source = "./modules/rds"
  
  subnets = [
    module.vpc.public_subnets[0]
  ]

  security_group_id = module.sg.db_sg_id

  environment    = var.environment  
  project_name   = var.project_name
  tags           = local.tags
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.tags
}

module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  zone_id     = var.hosted_zone_id

  tags = local.tags
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name        = var.project_name
  environment         = var.environment
  domain_name         = var.domain_name

  acm_certificate_arn = module.acm.certificate_arn

  s3_bucket_arn = module.s3.s3_bucket_arn

  tags = local.tags
}

resource "local_file" "ec2_key" {
  content  = module.ec2.private_key_pem
  filename = "${path.module}/ec2-key.pem"
  file_permission = "0600"
}

resource "null_resource" "ansible_provision" {
  depends_on = [module.ec2.public_ip]

  provisioner "local-exec" {
    command = <<EOT
      echo "[web]" > hosts.ini
      echo "${module.ec2.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${path.module}/ec2-key.pem" >> hosts.ini
      ansible-playbook -i hosts.ini main.yml
    EOT
  }
}
