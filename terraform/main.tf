terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  tags = var.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security"
  
  vpc_id = module.vpc.vpc_id
  tags   = var.common_tags
}

# Load Balancer Module
module "load_balancer" {
  source = "./modules/load_balancer"
  
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
  
  tags = var.common_tags
}

# Web Tier (Frontend)
module "web_tier" {
  source = "./modules/compute"
  
  name_prefix       = "web"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.web_security_group_id
  instance_type    = var.web_instance_type
  key_name         = var.key_name
  user_data        = file("${path.module}/scripts/web_userdata.sh")
  target_group_arn = module.load_balancer.target_group_arn
  
  tags = merge(var.common_tags, { Tier = "Web" })
}

# App Tier (Backend)
module "app_tier" {
  source = "./modules/compute"
  
  name_prefix       = "app"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnet_ids
  security_group_id = module.security_groups.app_security_group_id
  instance_type    = var.app_instance_type
  key_name         = var.key_name
  user_data        = file("${path.module}/scripts/app_userdata.sh")
  
  tags = merge(var.common_tags, { Tier = "App" })
}

# Database Tier
module "db_tier" {
  source = "./modules/compute"
  
  name_prefix       = "db"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = [module.vpc.private_subnet_ids[0]]
  security_group_id = module.security_groups.db_security_group_id
  instance_type    = var.db_instance_type
  key_name         = var.key_name
  user_data        = file("${path.module}/scripts/db_userdata.sh")
  
  tags = merge(var.common_tags, { Tier = "Database" })
}