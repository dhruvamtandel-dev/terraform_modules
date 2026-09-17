locals {
  flatten_ingress_rules = flatten([
    for sg_k, sg_v in var.security_groups : [
      for k, rule in sg_v.ingress_rules : {
        unique_key = "ingress-${sg_k}-${k}"

        target_sg_id    = aws_security_group.sg[sg_k].id
        cidr_block      = rule.cidr_block
        from_port       = rule.from_port
        to_port         = rule.to_port
        ip_protocol     = rule.ip_protocol
        source_group_id = rule.security_groups_key != null ? aws_security_group.sg[rule.security_groups_key].id : null
        prefix_list_ids = rule.prefix_list_ids
      }
    ]
  ])

  ingress_rules = { for ing_r in local.flatten_ingress_rules : ing_r.unique_key => ing_r }

  flatten_egress_rules = flatten([
    for sg_k, sg_v in var.security_groups : [
      for k, rule in sg_v.egress_rules : {
        unique_key = "ingress-${sg_k}-${k}"

        target_sg_id    = aws_security_group.sg[sg_k].id
        cidr_block      = rule.cidr_block
        from_port       = rule.from_port
        to_port         = rule.to_port
        ip_protocol     = rule.ip_protocol
        source_group_id = rule.security_groups_key != null ? aws_security_group.sg[rule.security_groups_key].id : null
        prefix_list_ids = rule.prefix_list_ids
      }
    ]

  ])

  egress_rules = { for eg_r in local.flatten_egress_rules : eg_r.unique_key => eg_r }
}