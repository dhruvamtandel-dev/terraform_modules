
// region 
variable "aws_region" {
  default     = "us-east-2"
  description = "proivde the region you want to use as default"
}


// VPC 

variable "vpc_cider" {
  type        = string
  description = "cidr block for the vpc"
}

variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}


// Subnets

variable "public_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    nat_creation      = optional(bool, false)
    map_public_ip     = optional(bool, true)
  }))
  description = "public subnets for vpc"
}


variable "private_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    nat_associate     = optional(bool, false)
  }))
  description = "private subnets for vpc"
}

variable "db_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "database subnets for vpc"
}


// Security Groups

variable "security_groups" {
  type = map(object({
    ingress_rules = list(object({
      from_port           = number
      to_port             = number
      ip_protocol         = string
      cidr_block          = optional(string)
      security_groups_key = optional(string)
      prefix_list_ids     = optional(list(string))
    }))

    egress_rules = optional(list(object({
      from_port           = optional(number)
      to_port             = optional(number)
      ip_protocol         = string
      cidr_block          = string
      security_groups_key = optional(string)
      prefix_list_ids     = optional(list(string))
    })))
  }))
  description = "all the security groups with the ingress rules and egress rules"
}


// alb

variable "lb_name" {
    type = string
    description = "Name of the load balancer"
}

variable "internal" {
    type = bool
    description = "true if internal flase if external"
}

variable "load_balancer_type" {
  type = string
  description = "type of the load balancer"
}

variable "load_balancer_subnet" {
  type = list(string)
  description = "value"
}


variable "target_group_resource_prefix" {
  description = "Prefix for target group names."
  type        = string
  default     = "alb-tg"
}

variable "target_groups" {
  description = "Map of target groups to create."

  type = map(object({
    port              = number
    protocol          = string
    target_type       = string
    health_check_path = optional(string, "/")
    health_check = optional(object({
      enabled             = optional(bool, true)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
      timeout             = optional(number, 5)
      interval            = optional(number, 30)
      matcher             = optional(string, "200")
    }), {})
  }))

  default = {}
}
variable "listeners" {
  type = map(object({
    port     = number
    protocol = string

    forward = list(object({
      target_name = string
      weight      = number
    }))
  }))
}