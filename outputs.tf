#RDS

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = module.rds.db_instance_master_user_secret_arn
}

output "RDS_HOST" {
  description = "The database instance connection endpoint (host)"
  value       = module.rds.db_instance_endpoint
}

output "RDS_USERNAME" {
  description = "Database username"
  value       = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string).username
  sensitive   = true
}

output "RDS_PASSWORD" {
  description = "Database password"
  value       = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string).password
  sensitive   = true 
}

#EC2
output "ec2_connection_string" {
  description = "EC2 connection string"
  value       = "ssh -i <your_key> ec2-user@ec2-${replace(module.ec2.public_ip, ".", "-")}.${var.region}.compute.amazonaws.com"
}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format"
  value       = module.ec2.private_key_pem
  sensitive   = true
}
