variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "web_subnet_1_cidr" {
  description = "CIDR block for the subnet_1"
  type        = string
}

variable "web_subnet_2_cidr" {
  description = "CIDR block for the subnet_2"
  type        = string
}
variable "app_subnet_1_cidr" {
  description = "CIDR block for the app subnet_1"
  type        = string
}

variable "app_subnet_2_cidr" {
  description = "CIDR block for the app subnet_2"
  type        = string
}

variable "db_subnet_1_cidr" {
  description = "CIDR block for the db subnet_1"
  type        = string
}
variable "db_subnet_2_cidr" {
  description = "CIDR block for the db subnet_2"
  type        = string
}

variable "subnet_1_az" {
  description = "Availability zone for subnet_1"
  type        = string
}

variable "subnet_2_az" {
  description = "Availability zone for subnet_2"
  type        = string
}
