#!/bin/bash
yum update -y
yum install -y git

# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create app directory
mkdir -p /opt/coffee-app
cd /opt/coffee-app

# Create package.json
cat > package.json << 'EOF'
{
  "name": "coffee-shop-backend",
  "version": "1.0.0",
  "description": "Coffee Shop Backend API",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "cors": "^2.8.5",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "dotenv": "^16.3.1"
  }
}
EOF

# Clone application code
cd /opt
git clone https://github.com/YOUR_USERNAME/coffee-shop-app.git
cd coffee-shop-app/application/backend

# Install dependencies
npm install

# Get database IP and create .env file
DB_SERVER_IP=$(aws ec2 describe-instances --region us-west-2 --filters "Name=tag:Name,Values=*db*" "Name=instance-state-name,Values=running" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
cat > .env << EOF
MONGODB_URI=mongodb://$DB_SERVER_IP:27017/coffeeshop
PORT=3000
NODE_ENV=production
EOF

# Copy application files
cp -r * /opt/coffee-app/
cd /opt/coffee-app

# Set permissions
chown -R ec2-user:ec2-user /opt/coffee-app

# Enable and start service
systemctl daemon-reload
systemctl enable coffee-app
systemctl start coffee-app