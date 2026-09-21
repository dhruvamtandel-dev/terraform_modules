variable "lb_name" {
  type        = string
  description = "Name of the load balancer"
}

variable "internal" {
  type        = bool
  description = "true if internal flase if external"
}

variable "load_balancer_type" {
  type        = string
  description = "type of the load balancer"
}

variable "load_balancer_sg_ids" {
  type        = list(string)
  description = "ids of the security groups for the load balancer"
}

variable "load_balancer_subnet" {
  type        = list(string)
  description = "value"
}

variable "vpc_id" {
  description = "VPC ID where the target groups will be created."
  type        = string
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

    target_groups = list(object({
      target_name = string
      weight      = number
    }))
  }))
}