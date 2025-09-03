module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  version = "2.1.0"

  key_name           = "ec2-access-key"
  create_private_key = true
 }

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name                   = "${var.project_name} Application Host"
  key_name               = module.key_pair.key_pair_name
  ami                    = "ami-0615f8fb30852b961"
  instance_type          = "t2.micro"
  monitoring             = true
  subnet_id              = var.subnets[0]  
  create_security_group  = false
  vpc_security_group_ids = [var.ec2_security_group_id]
  create_eip             = true
  
  tags = var.tags
} 
