locals {
  lb_security_groups_ids = [
    for key, value in module.security_groups.sg : value if contains(var.load_balancer_sg,key)
  ]

  lb_subnets_ids = [
    for key, value in module.vpc.public_subnet_ids : value if contains(var.load_balancer_subnet, key)
  ]

  lb_vpc_id = module.vpc.vpc_id

  lt_security_group_ids = [
    for key,value in module.security_groups.sg : value if contains(var.var.launch_template_sg,key)
  ]

  asg_subnets = [
    for key,value in module.vpc.public_subnet_ids : value
  ]

  asg_target_group_arns = [
    for key,value in module.application_load_balancer.target_group_arn : value
  ]

}


