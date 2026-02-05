variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "web_instance_type" {
  description = "Instance type for web tier"
  type        = string
  default     = "c7i-flex.large"
}

variable "app_instance_type" {
  description = "Instance type for app tier"
  type        = string
  default     = "c7i-flex.large"
}

variable "db_instance_type" {
  description = "Instance type for database tier"
  type        = string
  default     = "c7i-flex.large"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "CoffeeShop"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}