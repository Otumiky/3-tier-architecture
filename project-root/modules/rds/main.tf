# Primary RDS Instance
resource "aws_db_instance" "primary" {
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  publicly_accessible     = false
  multi_az                = true
  storage_type            = "gp2"
  vpc_security_group_ids  = [var.db_security_group_id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  backup_retention_period = var.db_backup_retention
  skip_final_snapshot     = var.skip_final_snapshot
  tags = {
    Name = "${var.db_name}-primary"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}