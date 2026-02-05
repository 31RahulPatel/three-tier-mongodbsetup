# Coffee Shop Project Structure

```
mongosetup/
├── README.md                           # Project overview
├── terraform/                          # Infrastructure as Code
│   ├── main.tf                        # Main Terraform configuration
│   ├── variables.tf                   # Input variables
│   ├── outputs.tf                     # Output values
│   ├── terraform.tfvars.example       # Example variables file
│   ├── modules/                       # Reusable Terraform modules
│   │   ├── vpc/                       # VPC module
│   │   │   ├── main.tf               # VPC resources
│   │   │   ├── variables.tf          # VPC variables
│   │   │   └── outputs.tf            # VPC outputs
│   │   ├── security/                  # Security Groups module
│   │   │   ├── main.tf               # Security group resources
│   │   │   ├── variables.tf          # Security variables
│   │   │   └── outputs.tf            # Security outputs
│   │   ├── load_balancer/             # Load Balancer module
│   │   │   ├── main.tf               # ALB resources
│   │   │   ├── variables.tf          # ALB variables
│   │   │   └── outputs.tf            # ALB outputs
│   │   └── compute/                   # EC2 Compute module
│   │       ├── main.tf               # EC2 and ASG resources
│   │       ├── variables.tf          # Compute variables
│   │       └── outputs.tf            # Compute outputs
│   └── scripts/                       # User data scripts
│       ├── web_userdata.sh           # Web tier setup script
│       ├── app_userdata.sh           # App tier setup script
│       └── db_userdata.sh            # Database tier setup script
├── application/                       # Application code
│   ├── frontend/                      # React frontend
│   │   ├── package.json              # Frontend dependencies
│   │   ├── public/
│   │   │   └── index.html            # HTML template
│   │   └── src/
│   │       ├── App.js                # Main React component
│   │       ├── App.css               # Main styles
│   │       ├── index.js              # React entry point
│   │       ├── index.css             # Global styles
│   │       ├── components/           # React components
│   │       │   ├── ProductList.js    # Product listing
│   │       │   ├── Cart.js           # Shopping cart
│   │       │   └── UserRegistration.js # User registration
│   │       └── services/
│   │           └── api.js            # API service layer
│   └── backend/                       # Node.js backend
│       └── package.json              # Backend dependencies
└── docs/                             # Documentation
    └── DEPLOYMENT.md                 # Deployment guide
```

## Architecture Components

### Infrastructure (Terraform)
- **VPC Module**: Creates isolated network environment
- **Security Module**: Manages security groups and access rules
- **Load Balancer Module**: Application Load Balancer for high availability
- **Compute Module**: Auto Scaling Groups for each tier

### Application Tiers
- **Web Tier**: React frontend served by Nginx
- **App Tier**: Node.js/Express API server
- **Data Tier**: MongoDB database

### Key Features
- **Modular Design**: Reusable Terraform modules
- **Security**: Proper network segmentation
- **Scalability**: Auto Scaling Groups
- **High Availability**: Multi-AZ deployment
- **Production Ready**: Monitoring, backups, security