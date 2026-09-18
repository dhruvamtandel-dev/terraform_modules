locals {
  server_sg_ids = [
    for sg_k, sg_v in module.security_groups.sg : sg_v if sg_k == "public_instance_sg"
  ]


  lb_security_groups_ids = [
    for key,value in module.security_groups.sg : value if key == "alb"
  ]

  lb_subnets_ids = [
    for key,value in module.vpc.public_subnet_ids : value if contains(var.load_balancer_subnet,key)
  ]

  lb_vpc_id = module.vpc.vpc_id

}


