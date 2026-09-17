
resource "aws_security_group" "sg" {
  for_each = var.security_groups

  name   = each.key
  vpc_id = var.vpc_id
  tags = {
    Name = "${each.key}-${var.suffix_sg_name}"
  }
}


resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  for_each = local.ingress_rules

  security_group_id            = each.value.target_sg_id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_block
  referenced_security_group_id = each.value.source_group_id
}

resource "aws_vpc_security_group_egress_rule" "sg_egress" {
  for_each = local.egress_rules

  security_group_id            = each.value.target_sg_id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_block
  referenced_security_group_id = each.value.source_group_id
}