output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer.dns_name
}

output "web_instance_ids" {
  description = "IDs of web tier instances"
  value       = module.web_tier.instance_ids
}

output "app_instance_ids" {
  description = "IDs of app tier instances"
  value       = module.app_tier.instance_ids
}

output "db_instance_id" {
  description = "ID of database instance"
  value       = module.db_tier.instance_ids[0]
}

output "db_private_ip" {
  description = "Private IP of database instance"
  value       = module.db_tier.private_ips[0]
}