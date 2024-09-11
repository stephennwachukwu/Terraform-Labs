terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# NETWORK MODULE SECTION

module "Network" {
  source = "./modules/Network"
}

# COMPUTE MODULE SECTION

module "Compute" {
  source                     = "./modules/Compute"
  public_cidrs               = module.Network.public_cidrs
  app_private_cidrs          = module.Network.app_private_cidrs
  presentation_layer_sg      = module.Network.presentation_layer_sg
  application_layer_sg       = module.Network.application_layer_sg
  presentation_layer_subnets = module.Network.presentation_layer_subnet
  application_layer_subnets  = module.Network.application_layer_subnet
  key_name                   = var.key_name
  presentation_layer_tg_arn  = module.Load-Balancer.presentation_layer_tg_arn
  application_layer_tg_arn   = module.Load-Balancer.application_layer_tg_arn
}

# LOAD-BALANCER MODULE SECTION

module "Load-Balancer" {
  source                    = "./modules/Load-Balancer"
  vpc_id                    = module.Network.vpc_id
  public_cidrs              = module.Network.public_cidrs
  app_private_cidrs         = module.Network.app_private_cidrs
  presentation_layer_subnet = module.Network.presentation_layer_subnet
  application_layer_subnet  = module.Network.application_layer_subnet
  presentation_layer_lb_sg  = module.Network.presentation_layer_lb_sg
  alb_sg                    = module.Network.alb_sg
  presentation_layer_asg_id = module.Compute.presentation_layer_asg_id
  application_layer_asg_id  = module.Compute.application_layer_asg_id
}

# KMS MODULE SECTION

module "KMS" {
  source = "./modules/KMS"
}

# RDS INSTANCE MODULE SECTION 

module "RDS" {
  source               = "./modules/RDS"
  vpc_id               = module.Network.vpc_id
  db_private_subnet_id = module.Network.data_layer_subnet
  data_layer_sg        = module.Network.data_layer_sg
  kms_key_id           = module.KMS.kms_key_id
  db_name = var.db_name 
  username = var.username
  password = var.password
}

# CLOUDWATCH ALARM

module "CloudWatch" {
  source                                    = "./modules/Cloudwatch_Alarm"
  data_layer_instance_id                    = module.RDS.rds_instance_id
  presentation_layer_autoscaling_group_name = module.Compute.presentation_layer_autoscaling_group_name
  application_layer_autoscaling_group_name  = module.Compute.application_layer_autoscaling_group_name
  endpoint                                  = "sample@email.com"
}

# WAF MODULE SECTION

module "WAF" {
  source  = "./modules/WAF"
  alb_arn = module.Load-Balancer.presentation_layer_lb_arn
}

# ROUTE_53 MODULE SECTION

module "Route_53" {
  source                     = "./modules/Route_53"
  presentation_layer_lb_dns  = module.Load-Balancer.presentation_layer_lb_dns
  presentation_layer_zone_id = module.Load-Balancer.presentation_layer_lb_zone_id
  domain_name                = "domainname.com"
}
