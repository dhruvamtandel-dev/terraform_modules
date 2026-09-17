output "vpc_id" {
  value = module.vpc.vpc_id
}

output "sg_ids" {
  value = local.server_sg_ids
}

output "sg" {
  value = module.security_groups.sg
}
