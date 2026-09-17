variable "vpc_cider" {
  type        = string
  description = "cidr block for the vpc"
}

variable "vpc_name" {
  type        = string
  description = "name of the vpc"
}

# variable "vpcs" {
#   type = map(object({
#     name       = string
#     cidr_block = string
#   }))
#   description = "map of vpc with there Name and cidr"
# }

variable "public_subnet" {
  type = map(object({
    # vpc_name          = string
    cidr_block        = string
    availability_zone = string
    nat_creation      = optional(bool, false)
    map_public_ip     = optional(bool, true)
  }))
  description = "public subnets for vpc"
}


variable "private_subnet" {
  type = map(object({
    # vpc_name          = string
    cidr_block        = string
    availability_zone = string
    nat_associate     = optional(bool, false)
  }))
  description = "private subnets for vpc"
}

variable "db_subnet" {
  type = map(object({
    # vpc_name          = string
    cidr_block        = string
    availability_zone = string
  }))
  description = "database subnets for vpc"
}


variable "suffix_for_public_route_table" {
  type        = string
  description = "suffix for name of the public route table"
  default     = "public_route_table"
}

variable "allow_all_ip_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "include all the ip in this cidr"

}