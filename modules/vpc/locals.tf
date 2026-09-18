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
}
