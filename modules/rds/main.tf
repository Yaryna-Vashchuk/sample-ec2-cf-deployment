locals {
  db_instance_name = "${var.environment}-${var.project_name}-database"
  db_name = "${var.environment}db"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  identifier        = local.db_instance_name

  engine            = "postgres"
  engine_version    = "17.4"
  instance_class    = "db.t4g.micro"
  allocated_storage = 5

  manage_master_user_password          = true

  db_name  = local.db_name
  username = "postgres"
  port     = "5432"

  vpc_security_group_ids = [var.security_group_id]

  create_db_subnet_group = true
    subnet_ids             = [
      var.subnets[0]
    ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # DB parameter group
  family = "postgres17"

  # DB option group
  major_engine_version = "17.4"

  deletion_protection = false
  
  publicly_accessible = var.environment != "prod" ? true : false

  tags = var.tags
}