# Git-Based Deployment Guide

## Recommended Approach: Git + CI/CD

### Why Git over Containers?
- **Simpler**: No container orchestration complexity
- **Faster**: Direct deployment to EC2
- **Cost-effective**: No additional container services
- **Version control**: Easy rollbacks and tracking

## Setup Steps

### 1. Push Code to GitHub
```bash
git init
git add .
git commit -m "Initial coffee shop app"
git remote add origin https://github.com/YOUR_USERNAME/coffee-shop-app.git
git push -u origin main
```

### 2. Update Terraform Scripts
Replace `YOUR_USERNAME` in user data scripts with your GitHub username:
- `terraform/scripts/web_userdata.sh`
- `terraform/scripts/app_userdata.sh`

### 3. Deploy Infrastructure
```bash
cd terraform
terraform apply
```

### 4. Configure GitHub Secrets
Add to GitHub repository secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 5. Enable SSM on EC2 Instances
Add IAM role with `AmazonSSMManagedInstanceCore` policy to EC2 instances.

## Deployment Flow

1. **Push to main branch** → Triggers GitHub Actions
2. **Tests run** → Frontend/backend builds
3. **Deploy** → Updates EC2 instances via AWS SSM
4. **Zero downtime** → Rolling updates

## Manual Deployment (Alternative)
```bash
# SSH to instances and run:
cd /opt/coffee-shop-app
git pull origin main

# Web tier
cd application/frontend
npm run build
cp -r build/* /var/www/html/
systemctl reload nginx

# App tier  
cd application/backend
npm install
systemctl restart coffee-app
```

## Benefits
- ✅ Version control
- ✅ Automated testing
- ✅ Easy rollbacks
- ✅ Environment consistency
- ✅ Team collaboration