variable "vpc_id" {
  type        = string
  description = "VPC id in which we need to create the security group"
}

variable "security_groups" {
  type = map(object({
    ingress_rules = list(object({
      from_port           = number
      to_port             = number
      ip_protocol         = string
      cidr_block          = optional(string)
      security_groups_key = optional(string)
      prefix_list_ids     = optional(list(string), [])
    }))

    egress_rules = optional(list(object({
      from_port           = optional(number)
      to_port             = optional(number)
      ip_protocol         = string
      cidr_block          = optional(string)
      security_groups_key = optional(string)
      prefix_list_ids     = optional(list(string), [])
    })))
  }))
  description = "all the security groups with the ingress rules and egress rules"
}

variable "suffix_sg_name" {
  type        = string
  default     = "security-groups"
  description = "Add after the key of security_group variable for sg name"
}