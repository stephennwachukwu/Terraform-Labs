# PRESENTATION LAYER LOAD BALANCER 

resource "aws_lb" "presentation_layer_lb" {
  name = var.lb_name
  internal = false
  load_balancer_type = var.lb_type
  security_groups = [var.presentation_layer_lb_sg]
  subnets = tolist(var.presentation_layer_subnet)
}

# LISTENER FOR PRESENTATION LAYER LOAD BALANCER 

resource "aws_lb_listener" "presentation_layer_lb_listener" {
  load_balancer_arn = aws_lb.presentation_layer_lb.arn
  port = var.listener_port
  protocol = var.listener_protocol 
  default_action {
    type = "forward"    
    target_group_arn = aws_lb_target_group.presentation_layer_lb_tg.arn
  }
}

# LISTENER RULE FOR PRESENTATION LAYER LOAD BALANCER 

resource "aws_lb_listener_rule" "presentation_layer_lb_listener_rule" {
  listener_arn = "${aws_lb_listener.presentation_layer_lb_listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.presentation_layer_lb_tg.arn}"
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# PRESENTATION LAYER LOAD BALANCER TARGET GROUP CONFIGURATION

resource "aws_lb_target_group" "presentation_layer_lb_tg" {
  name = var.lb_tg_name
  protocol = var.tg_protocol
  port = var.tg_port
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = var.tg_protocol
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
}

# PRESENTATION LAYER LOAD BALANCER TARGET GROUP REGISTRATION

/* resource "aws_lb_target_group_attachment" "presentation_layer_target_group_attachment" {
  #count = length(var.public_cidrs)
  target_group_arn = aws_lb_target_group.presentation_layer_lb_tg.arn
  target_id        = var.presentation_layer_asg_id
  port             = var.tg_port
} */

# APPLICATION LAYER LOAD BALANCER 

resource "aws_lb" "application_layer_lb" {
  name = var.app_lb_name
  internal = true
  load_balancer_type = var.lb_type
  security_groups = [var.alb_sg]
  subnets = tolist(var.application_layer_subnet)
}

# LISTENER FOR APPLICATION LAYER LOAD BALANCER

resource "aws_lb_listener" "application_layer_lb_listener" {
  load_balancer_arn = aws_lb.application_layer_lb.arn
  port = var.app_listener_port
  protocol = var.listener_protocol 
  default_action {
    type = "forward"    
    target_group_arn = aws_lb_target_group.application_layer_lb_tg.arn
  }
}

# LISTENER RULE FOR APPLICATION LAYER LOAD BALANCER

resource "aws_lb_listener_rule" "application_layer_lb_listener_rule" {
  listener_arn = "${aws_lb_listener.application_layer_lb_listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.application_layer_lb_tg.arn}"
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# APPLICATION LAYER LOAD BALANCER TARGET GROUP CONFIGURATION 

resource "aws_lb_target_group" "application_layer_lb_tg" {
  name = var.app_lb_tg_name
  protocol = var.tg_protocol
  port = var.app_tg_port
  vpc_id = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/"
    protocol            = var.tg_protocol
    matcher             = var.health_check_matcher
    interval            = var.health_check_interval
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
}

# APPLICATION  LAYER LOAD BALANCER TARGET GROUP REGISTRATION

/* resource "aws_lb_target_group_attachment" "application_layer_target_group_attachment" {
  #count = length(var.app_private_cidrs)
  target_group_arn = aws_lb_target_group.application_layer_lb_tg.arn
  target_id        = var.application_layer_asg_id
  port             = var.app_tg_port
} */