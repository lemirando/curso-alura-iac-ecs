resource "aws_security_group" "app_lb_sg_us_east_1" {
  name = "app-lb-sg-us-east-1"
  vpc_id = module.vpc_ecs.vpc_id
}

resource "aws_security_group_rule" "app_lb_sg_ingress_rule_us_east_1" {
  type = "ingress"
  from_port = 8000
  to_port = 8000
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.app_lb_sg_us_east_1.id
}

resource "aws_security_group_rule" "app_lb_sg_egress_rule_us_east_1" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.app_lb_sg_us_east_1.id
}

resource "aws_security_group" "private_net_sg_us_east_1" {
  name = "private-net-sg-us-east-1"
  vpc_id = module.vpc_ecs.vpc_id
}

resource "aws_security_group_rule" "private_net_sg_ingress_rule" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.app_lb_sg_us_east_1.id
  security_group_id = aws_security_group.private_net_sg_us_east_1.id
}

resource "aws_security_group_rule" "private_net_sg_egress_rule" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.private_net_sg_us_east_1.id
}