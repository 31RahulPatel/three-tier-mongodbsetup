# Coffee Shop Deployment Guide

## Prerequisites
- AWS CLI configured
- Terraform installed
- EC2 Key Pair created
- Domain name (optional)

## Infrastructure Deployment

### 1. Configure Terraform Variables
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 3. Get Outputs
```bash
terraform output
```

## Post-Deployment Configuration

### 1. Update Application Configuration
After deployment, update the following files with actual IP addresses:

**Web Tier**: Update nginx configuration in `/etc/nginx/nginx.conf`
- Replace `APP_SERVER_IP` with actual app server private IP

**App Tier**: Update environment variables
- Replace `DB_SERVER_IP` with actual database server private IP

### 2. MongoDB Setup
SSH into the database instance and run:
```bash
# Connect to MongoDB
mongo

# Create database and user
use coffeeshop
db.createUser({
  user: "coffeeapp",
  pwd: "secure_password",
  roles: ["readWrite"]
})
```

### 3. Application Deployment

**Frontend**:
```bash
cd application/frontend
npm install
npm run build
# Copy build files to web server
```

**Backend**:
```bash
cd application/backend
npm install
# Update .env file with MongoDB connection string
npm start
```

## Connection Strings

### MongoDB Connection String
```
mongodb://coffeeapp:secure_password@<DB_PRIVATE_IP>:27017/coffeeshop
```

### Application URLs
- **Frontend**: `http://<LOAD_BALANCER_DNS>`
- **Backend API**: `http://<LOAD_BALANCER_DNS>/api`

## Security Considerations

1. **Security Groups**: Properly configured for minimal access
2. **Private Subnets**: App and DB tiers isolated
3. **NAT Gateway**: Secure internet access for private instances
4. **MongoDB**: Authentication enabled
5. **HTTPS**: Configure SSL certificate for production

## Monitoring and Maintenance

1. **CloudWatch**: Monitor instance health
2. **Backups**: MongoDB automated backups configured
3. **Updates**: Regular security updates
4. **Scaling**: Auto Scaling Groups configured

## Troubleshooting

### Common Issues
1. **Connection refused**: Check security groups
2. **MongoDB connection**: Verify IP addresses and credentials
3. **Load balancer health checks**: Ensure applications are running

### Logs Location
- **Web**: `/var/log/nginx/`
- **App**: `journalctl -u coffee-app`
- **DB**: `/var/log/mongodb/mongod.log`