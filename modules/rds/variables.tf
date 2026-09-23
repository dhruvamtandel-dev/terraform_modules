variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for subnet groups"
}

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

variable "db_identifier" {
  type        = string
  description = "Identifier for the db instance"
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

variable "max_allocated_storage" {
  type        = number
  description = "Maximum value the db will scale to in auto-scaling"
  default     = 0
}

variable "multi_az" {
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

variable "db_security_group_ids" {
  type        = list(string)
  description = "List of the security group ids for db instance"
}

variable "db_tags" {
  type        = map(string)
  description = "tags to add to the db instance"
}

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