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

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups ids for launch template"
}

variable "monitoring_enable" {
  type        = bool
  description = "True if need to enable monitoring in ec2 or false is dont want monitoring"
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

variable "asg_subnets" {
  type        = list(string)
  description = "List of the subnet in which we need to launch the instance"
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of the arns of the target groups"
}


variable "asg_scaling_policy_name" {
  type = string
  description = "Name of the auto-scaling policy name"
}

variable "scaling_policy_type" {
  type = string
  default = "TargetTrackingScaling"
  description = "Type of the scaling policy"
}

variable "autoscaling_policy_predefined_metric_type" {
  type = string
  description = "Type of the predifined metric for the scaling policy"
}

variable "target_value_for_scaling" {
  type = number
  description = "Target value for scaling"
  
}