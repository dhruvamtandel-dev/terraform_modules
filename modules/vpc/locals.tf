locals {
  nat_az = {
    for key, subnet in var.public_subnet :
    subnet.availability_zone => key
    if subnet.nat_creation == true
  }

  nat_route_subnets = {
    for key, subnet in var.private_subnet :
    key => subnet
    if subnet.nat_associate == true
  }

#   public_route_table_vpcs = toset([
#     for key, subnet in var.public_subnet : aws_subnet.vpc_public_subnet[subnet.vpc_name]
#   ])
}
