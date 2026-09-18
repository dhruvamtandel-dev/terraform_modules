resource "aws_lb" "alb" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.load_balancer_sg_ids
  subnets            = var.load_balancer_subnet
}


resource "aws_lb_target_group" "alb_tg" {
  for_each = var.target_groups

  name        = "${var.target_group_resource_prefix}-${each.key}"
  vpc_id      = var.vpc_id
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type

  health_check {
    enabled             = each.value.health_check.enabled
    path                = each.value.health_check_path
    protocol            = each.value.protocol
    port                = each.value.port
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    timeout             = each.value.health_check.timeout
    interval            = each.value.health_check.interval
    matcher             = each.value.health_check.matcher
  }
}


resource "aws_lb_listener" "lb_listener" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type = "forward"

    forward {
      dynamic "target_group" {
        for_each = each.value.forward

        content {
          arn    = aws_lb_target_group.alb_tg[target_group.value.target_name].arn
          weight = target_group.value.weight
        }
      }
    }
  }
}


output "dns" {
  value = aws_lb.alb.dns_name
}