
variable "iam_roles" {
  type = map(object({
    name               = string
    assume_role_policy = string
  }))
  description = "all the iam role"
}
