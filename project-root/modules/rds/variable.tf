# RDS Variables
variable "db_allocated_storage" {
  description = "The allocated storage in GBs for the RDS instance."
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "The database engine to use (e.g., mysql, postgres)."
  type        = string
}

variable "db_engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "db_username" {
  description = "The master username for the database."
  type        = string
}

variable "db_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "db_security_group_id" {
  description = "The security group ID for the RDS instance."
  type        = string
}

variable "db_subnet_ids" {
  description = "A list of subnet IDs for the RDS subnet group."
  type        = list(string)
}
variable "db_subnet_group" {
  description = " RDS subnet group."
  type        = list(string)
}
variable "db_backup_retention" {
  description = "The number of days to retain database backups."
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Determines whether to skip the final snapshot before deleting the instance."
  type        = bool
  default     = true
}
