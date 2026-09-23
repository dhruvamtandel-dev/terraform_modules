# output "load_balancer_dns" {
#   value = module.application_load_balancer.dns
# }

output "db_instance_endpoint" {
  value = module.rds.db_instance_endpoint
}