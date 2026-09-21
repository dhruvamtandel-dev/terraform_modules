
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