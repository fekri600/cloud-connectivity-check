# outputs.tf
output "vpc_id" {
  value       = module.network.vpc_id
  description = "VPC ID"
}

