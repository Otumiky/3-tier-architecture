#Application Load Balancer
resource "aws_lb" "elb" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups = [var.elb_security_group.id]

  enable_deletion_protection = false
}

#Listener for LoadBalancer
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_target.arn
  }
}
#Target Group
resource "aws_lb_target_group" "web_target" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  } 
}