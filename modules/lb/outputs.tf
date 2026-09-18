output "dns" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
    value = {
        for key,value in aws_aws_lb_target_group.alb_tg : key => value.arn 
    }
}