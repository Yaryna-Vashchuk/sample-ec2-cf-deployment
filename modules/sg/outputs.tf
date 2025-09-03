output "ec2_security_group_id" {
  description = "The ID of the EC2 security group"
  value       = module.ec2_sg.security_group_id
}

output "db_sg_id" {
  description = "The ID of the DB security group"
  value       = module.db_sg.security_group_id
}
