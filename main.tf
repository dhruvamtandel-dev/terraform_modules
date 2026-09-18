module "vpc" {
  source = "./modules/vpc"
  vpc_name       = var.vpc_name
  vpc_cider      = var.vpc_cider
  private_subnet = var.private_subnet
  public_subnet  = var.public_subnet
  db_subnet      = var.db_subnet
}

module "security_groups" {
  source          = "./modules/sg"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}


module "Application_load_balancer" {
  source = "./modules/lb"
  lb_name = var.lb_name
  internal = var.internal
  load_balancer_type = var.load_balancer_type
  load_balancer_sg_ids = local.lb_security_groups_ids
  load_balancer_subnet = local.lb_subnets_ids
  vpc_id = local.lb_vpc_id
  target_groups = var.target_groups
  listeners = var.listeners
}


# resource "aws_instance" "server" {
#   ami = "ami-049a0d228b0190f01"
#   instance_type = "t3.micro"
#   vpc_security_group_ids = local.server_sg_ids
#   associate_public_ip_address = true
#   subnet_id = module.vpc.public_subnet_ids["pu_sub_1"]

#   tags = {
#     "Name"         = "test-ec2"
#     "Owner"        = "dhruvam.tandel@intuitive.ai"
#     "Project"      = "test"
#     "Resourcetype" = "instance"
#   }
#   volume_tags = {
#     "Resourcetype" = "volumn"
#   }
# }