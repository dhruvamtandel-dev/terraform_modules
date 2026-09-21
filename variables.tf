
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

variable "load_balancer_subnet" {
  type        = list(string)
  description = "value"
}

variable "load_balancer_sg" {
  type = list(string)
  description = "List of the name of load balancer security group name"
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


// iam 

variable "assume_policy_principals" {
  type = map(object({
      type        = string
      identifiers = list(string)
    }))
  
  description = "priciples which need to assume this role"
}


variable "role_name" {
  type        = string
  description = "Name of the role"
}


variable "policys_to_attach" {
  type        = set(string)
  default     = []
  description = "arns of the policy which need to be attach to the role"
}


variable "role_policy_document" {
  type = list(string)
  default = []
  description = "inline policy document which need to attach to the role."
}

// auto-scaling-group

variable "ec2_instance_profile" {
    type = object({
    name = string
    role = string
    })
}

variable "launch_template_name_prefix" {
  type = string
  description = "Prefix to add in the launch template name"
}

variable "image_id" {
    type = string
    description = "Ami id for the launch template"
}

variable "instance_type" {
  type = string
  description = "Type of the instance for launch template"
}


variable "monitoring_enable" {
  type = bool
  description = "True if need to enable monitoring in ec2 or false is dont want monitoring"
}

variable "launch_template_sg" {
  type = list(string)
  description = "Name of the security groups for launch template"
}


variable "launch_templete_tag" {
  type = map(map(string))
  description = "All the tags which is attach to the ec2 which created with this launch tmeplete"
}

variable "user_data_for_launch_template" {
  type = string
  description = "User data script to add to the launch template"
}

variable "asg_name" {
    type = string
    description = "Name of the auto-scaling group"
}

variable "asg_max_size" {
    type = number
    description = "Maximum number of instance to be launch during scaling"
}

variable "asg_min_size" {
    type = number
    description = "Minimum number of instance to be launch in auto-scaling group"
}

variable "asg_desired_capacity" {
    type = number
    description = "Desired number of instance need to be launch in the auto-scaling group" 
}

variable "asg_health_check_type" {
    type = string
    description = "Type of health check in auto-scaling group"
}

variable "health_check_grace_period" {
    type = number
    description = "Grace period for auto-scaling group"
}
