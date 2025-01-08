variable "vpc_id" {}
variable "elb_security_group" {}
variable "subnet_ids" {
  description = "List of subnet IDs where the ALB will be deployed"
  type        = list(string)
}