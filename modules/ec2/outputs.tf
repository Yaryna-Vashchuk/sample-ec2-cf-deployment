output "public_ip" {
  description = "The public IP address"
  value = module.ec2_instance.public_ip
}

output "private_key_pem" {
  description = "Private key"
  value       = module.key_pair.private_key_pem
}