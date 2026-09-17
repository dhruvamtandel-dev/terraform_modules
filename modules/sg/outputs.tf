output "sg" {
    value = {for key,value in aws_security_group.sg : key => value.id }
    description = "map of security groups name => security group id"
}
