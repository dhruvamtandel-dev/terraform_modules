resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "db_instance" {
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  identifier           = var.db_identifier

  max_allocated_storage = var.max_allocated_storage
  multi_az              = var.multi_az
  username              = var.db_username
  password              = var.manage_master_user_password == false ? var.db_password : null

  manage_master_user_password   = var.manage_master_user_password
  master_user_secret_kms_key_id = var.manage_master_user_password == true ? var.kms_key_id_for_master_password : null
  backup_retention_period       = var.backup_retention_period

  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = var.db_security_group_ids

  tags = var.db_tags
}

resource "aws_db_instance" "replica" {
  for_each = var.db_read_replica

  identifier          = each.value.identifier
  replicate_source_db = aws_db_instance.db_instance.id
  instance_class      = each.value.instance_class

  vpc_security_group_ids = var.db_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  skip_final_snapshot = true

}