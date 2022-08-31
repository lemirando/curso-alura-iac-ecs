resource "aws_lb" "app_lb_us_east_1" {
  name = "app-lb-us-east-1"
  security_groups = [ aws_security_group.app_lb_sg_us_east_1.id ]
  subnets = module.vpc_ecs.public_subnets
}

resource "aws_lb_listener" "app_lb_listener_http_us_east_1" {
 load_balancer_arn = aws_lb.app_lb_us_east_1.arn
 port = 8000
 protocol = "HTTP"
 default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.app_lb_target_group_us_east_1.arn
 } 
}

resource "aws_lb_target_group" "app_lb_target_group_us_east_1" {
  name = "app-lb-target-group-us-east-1"
  port = 8000
  protocol = "http"
  target_type = "ip"
  vpc_id = module.vpc_ecs.vpc_id
}

output "app_lb_ip_us_east_1" {
  value = aws_lb.app_lb_us_east_1.dns_name
}