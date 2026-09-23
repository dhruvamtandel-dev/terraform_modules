
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
  type        = list(string)
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
  type        = list(string)
  default     = []
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
  type        = string
  description = "Prefix to add in the launch template name"
}

variable "image_id" {
  type        = string
  description = "Ami id for the launch template"
}

variable "instance_type" {
  type        = string
  description = "Type of the instance for launch template"
}


variable "monitoring_enable" {
  type        = bool
  description = "True if need to enable monitoring in ec2 or false is dont want monitoring"
}

variable "launch_template_sg" {
  type        = list(string)
  description = "Name of the security groups for launch template"
}


variable "launch_templete_tag" {
  type        = map(map(string))
  description = "All the tags which is attach to the ec2 which created with this launch tmeplete"
}

variable "user_data_for_launch_template" {
  type        = string
  description = "User data script to add to the launch template"
}

variable "asg_name" {
  type        = string
  description = "Name of the auto-scaling group"
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instance to be launch during scaling"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instance to be launch in auto-scaling group"
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instance need to be launch in the auto-scaling group"
}

variable "asg_health_check_type" {
  type        = string
  description = "Type of health check in auto-scaling group"
}

variable "health_check_grace_period" {
  type        = number
  description = "Grace period for auto-scaling group"
}


// asg-scaling policy
variable "auto_scaling_group_scaling_policy_name" {
  type        = string
  description = "Name of the scaling policy in auto-scaling group"
}

variable "predefined_metric_type_for_scaling_policy" {
  type        = string
  description = "Type of the predifined metric for scaling policy"
}

variable "target_value_for_scaling" {
  type        = number
  description = "Target value for scaling"
}

// rds
variable "db_allocated_storage" {
  type        = number
  description = "Storage to allocate to the db instance"
  default     = 20
  validation {
    condition     = var.db_allocated_storage >= 20
    error_message = "Provide the storage value 20 or more than that"
  }
}

variable "db_name" {
  type        = string
  description = "Name of the database"
}

variable "db_engine" {
  type        = string
  description = "Engine type for data-base"
}

variable "db_engine_version" {
  type        = string
  description = "Version of the engine to used for data-base"
}

variable "db_instance_class" {
  type        = string
  description = "Instance class of the db instance"
}

variable "db_identifier" {
  type        = string
  description = "Identifier for the db instance"
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum value the db will scale to in auto-scaling"
  default     = 0
}

variable "db_multi_az" {
  type        = bool
  description = "true if need the db in multi az"
  default     = false
}

variable "db_username" {
  type        = string
  description = "User name for data-base"
}

variable "db_password" {
  type        = string
  description = "password to access the data-base"
  default     = null
}

variable "manage_master_user_password" {
  type        = bool
  description = "True if need to manage password in the secret-manager"
  default     = false

  validation {
    condition     = (var.manage_master_user_password == true && var.db_password == null)
    error_message = "Can't use this because you providing password"
  }
  validation {
    condition     = !(var.manage_master_user_password == false && var.db_password == null)
    error_message = "you must have to provide on of the following attribute either db_password or manage_master_user_password"
  }
}

variable "kms_key_id_for_master_password" {
  type        = string
  description = "kms key id for encryption of the managed master user password"
  default     = null
}
variable "skip_final_snapshot" {
  type        = bool
  description = "False if need final snapshot before destroy db instance"
  default     = true
}


variable "db_tags" {
  type        = map(string)
  description = "tags to add to the db instance"
}

//db read replicas
variable "db_read_replica" {
  type = map(object({
    identifier     = string
    instance_class = string
  }))
  description = "Set of object including configuration for read replica"
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days the database snapshot are kept before automated delete"
  default     = 0
}