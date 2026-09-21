resource "aws_iam_instance_profile" "instance_profile" {
  count = length(var.ec2_instance_profile) == 0 ? 0 : 1

  name = var.ec2_instance_profile.name
  role = var.ec2_instance_profile.role
}

resource "aws_launch_template" "ec2_launch_templete" {
  name_prefix            = var.launch_template_name_prefix
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance_profile[0].arn
  }
  monitoring {
    enabled = var.monitoring_enable
  }

  dynamic "tag_specifications" {
    for_each = var.launch_templete_tag
    content {
      resource_type = tag_specifications.key
      tags = tag_specifications.value
    }
  }
  user_data = base64encode(var.user_data_for_launch_template)
}



resource "aws_autoscaling_group" "asg" {
  name             = var.asg_name
  max_size         = var.asg_max_size
  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_capacity

  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = aws_launch_template.ec2_launch_templete.id
    version = aws_launch_template.ec2_launch_templete.latest_version
  }
  vpc_zone_identifier = var.asg_subnets

  target_group_arns = var.target_group_arns
}