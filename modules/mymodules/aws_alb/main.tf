resource "aws_lb" main {
  name               = "LB-for-VPC-${var.project_name}"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_groups_id]
  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_alb_target_group" "apache_app" {
  name = "${var.project_name}-target-group2"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
/*  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }*/
  tags = {
    Name = "${var.project_name}-alb-target-group2"
  }
}


data "aws_alb_target_group" "main" {
  arn  = aws_alb_target_group.apache_app.arn
}

resource "aws_alb_target_group_attachment" "instance1_subnet1" {
  target_group_arn = data.aws_alb_target_group.main.arn
  target_id        = var.aws_instances_subnet1_ids
  port             = 80
}

data "aws_alb" "main" {
  arn  = aws_lb.main.arn
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = data.aws_alb.main.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.apache_app.id
    type = "forward"
  }
}
