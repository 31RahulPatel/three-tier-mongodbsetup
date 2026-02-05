# Coffee Shop Three-Tier Application

## Architecture
- **Web Tier**: React frontend (Public Subnet)
- **App Tier**: Node.js backend (Private Subnet)
- **Data Tier**: MongoDB (Private Subnet)

## Infrastructure
- VPC with public/private subnets
- Application Load Balancer
- NAT Gateway for private subnet internet access
- Security Groups with proper access controls

## Deployment
```bash
# Deploy infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# Deploy application
cd ../application
npm install
npm run build
```

## Features
- User registration/authentication
- Product catalog
- Shopping cart functionality
- Order management