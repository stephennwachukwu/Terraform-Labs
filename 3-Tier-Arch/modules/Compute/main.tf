data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# PRESENTATION LAYER LAUNCH TEMPLATE

resource "aws_launch_template" "frontend_server" {
  name = "frontend_server_launch_template"
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.frontend_server_instance_type
  key_name = var.key_name

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip
    security_groups = [var.presentation_layer_sg]
  }

  /* vpc_security_group_ids = [var.presentation_layer_sg] */

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "frontend_server_instance_template"
    }
  }
}

# APPLICATION_LAYER LAUNCH TEMPLATE

resource "aws_launch_template" "application_server" {
  name = "application_server_launch_template"
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.application_server_instance_type
  key_name = var.key_name

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.app_associate_public_ip
    security_groups = [var.application_layer_sg]
  }

  /* vpc_security_group_ids = [var.application_layer_sg] */

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "application_server_instance_template"
    }
  }
}

###############################################################
                  #AUTOSCALING GROUP
###############################################################

# PRESENTATION LAYER AUTOSCALING GROUP

resource "aws_autoscaling_group" "presentation_layer_autoscaling_group" {
  target_group_arns = [var.presentation_layer_tg_arn]
  vpc_zone_identifier = tolist(var.presentation_layer_subnets)
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_grace_period = 600
  health_check_type = "ELB"
  default_cooldown = 240

  launch_template {
    id      = aws_launch_template.frontend_server.id
    version = "$Latest"
  }
}

# APPLICATION LAYER AUTOSCALING GROUP 

resource "aws_autoscaling_group" "application_layer_autoscaling_group" {
  target_group_arns = [var.application_layer_tg_arn]
  vpc_zone_identifier = tolist(var.application_layer_subnets)
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_grace_period = 600
  health_check_type = "ELB"
  default_cooldown = 240

  launch_template {
    id      = aws_launch_template.application_server.id 
    version = "$Latest"
  }
}

##################################################################
              # AUTOSCALING GROUP ATTACHMENT
##################################################################

# Create a new ALB Target Group attachment for presentation layer ASG

resource "aws_autoscaling_attachment" "presentation_layer_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.presentation_layer_autoscaling_group.id 
  lb_target_group_arn    = var.presentation_layer_tg_arn
}


# Create a new ALB Target Group attachment for application layer ASG

resource "aws_autoscaling_attachment" "application_layer_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.application_layer_autoscaling_group.id 
  lb_target_group_arn    = var.application_layer_tg_arn
}
