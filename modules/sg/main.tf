module "ec2_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "5.3.0"

    name        = "ec2_sg"
    description = "EC2 machine SG"
    vpc_id      = var.vpc_id

    ingress_with_cidr_blocks = [
    {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "SSH access"
        cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "${var.environment}-db-sg"
  description = "Security group for ${var.environment} DB instance"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = [var.vpc_cidr_block]
  ingress_rules            = ["postgresql-tcp"]

  ingress_with_source_security_group_id = [
    {
      description              = "EC2 access"
      rule                     = "postgresql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "public"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = var.tags
}