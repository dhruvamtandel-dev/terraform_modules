module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = var.vpc_name
  vpc_cider      = var.vpc_cider
  private_subnet = var.private_subnet
  public_subnet  = var.public_subnet
  db_subnet      = var.db_subnet
}

module "security_groups" {
  source          = "./modules/sg"
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}


# module "application_load_balancer" {
#   source               = "./modules/lb"
#   lb_name              = var.lb_name
#   internal             = var.internal
#   load_balancer_type   = var.load_balancer_type
#   load_balancer_sg_ids = local.lb_security_groups_ids
#   load_balancer_subnet = local.lb_subnets_ids
#   vpc_id               = local.lb_vpc_id
#   target_groups        = var.target_groups
#   listeners            = var.listeners
# }

# data "aws_iam_policy_document" "ec2" {
#   statement {
#     effect    = "Allow"
#     actions   = ["ec2:*"]
#     resources = ["*"]
#   }
# }

# data "aws_iam_policy_document" "s3" {
#   statement {
#     actions   = ["s3:*"]
#     resources = ["*"]
#   }
# }

# module "role_for_launch_templete" {
#   source                   = "./modules/iam"
#   role_name                = var.role_name
#   assume_policy_principals = var.assume_policy_principals
#   # role_policy_document     = [data.aws_iam_policy_document.ec2.json, data.aws_iam_policy_document.s3.json]
#   policys_to_attach = var.policys_to_attach
# }

# module "auto_scaling_group" {
#   source = "./modules/asg"

#   //launch template
#   ec2_instance_profile          = var.ec2_instance_profile
#   launch_template_name_prefix   = var.launch_template_name_prefix
#   image_id                      = var.image_id
#   instance_type                 = var.instance_type
#   security_group_ids            = local.lt_security_group_ids
#   monitoring_enable             = var.monitoring_enable
#   launch_templete_tag           = var.launch_templete_tag
#   user_data_for_launch_template = file(var.user_data_for_launch_template)

#   // asg
#   asg_name                  = var.asg_name
#   asg_max_size              = var.asg_max_size
#   asg_min_size              = var.asg_min_size
#   asg_desired_capacity      = var.asg_desired_capacity
#   asg_health_check_type     = var.asg_health_check_type
#   health_check_grace_period = var.health_check_grace_period
#   asg_subnets               = local.asg_subnets
#   target_group_arns         = local.asg_target_group_arns

#   //scaling
#   asg_scaling_policy_name                   = var.auto_scaling_group_scaling_policy_name
#   autoscaling_policy_predefined_metric_type = var.predefined_metric_type_for_scaling_policy
#   target_value_for_scaling                  = var.target_value_for_scaling

# }


module "rds" {
  source = "./modules/rds"
  //subnet groups
  db_subnet_ids = local.db_subnet_ids

  //db instance
  db_name                        = var.db_name
  db_engine                      = var.db_engine
  db_engine_version              = var.db_engine_version
  db_instance_class              = var.db_instance_class
  db_allocated_storage           = var.db_allocated_storage
  db_identifier                  = var.db_identifier
  multi_az                       = var.db_multi_az
  db_username                    = var.db_username
  manage_master_user_password    = var.manage_master_user_password
  kms_key_id_for_master_password = var.kms_key_id_for_master_password
  backup_retention_period        = var.backup_retention_period
  db_security_group_ids          = local.db_security_group_ids
  db_tags                        = var.db_tags

  // replica
  db_read_replica = var.db_read_replica
}

