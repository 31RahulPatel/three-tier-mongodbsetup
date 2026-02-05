#!/bin/bash
yum update -y
yum install -y nginx nodejs npm git

# Install Node.js 18
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Configure nginx
cat > /etc/nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        root /var/www/html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        location /api/ {
            proxy_pass http://APP_SERVER_IP:3000/;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
        }
    }
}
EOF

# Create basic HTML page
mkdir -p /var/www/html
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Coffee Shop</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .header { text-align: center; margin-bottom: 30px; }
        .products { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .product { border: 1px solid #ddd; padding: 15px; border-radius: 8px; }
        .btn { background: #8B4513; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .cart { position: fixed; top: 20px; right: 20px; background: #333; color: white; padding: 10px; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>☕ Coffee Shop</h1>
            <p>Welcome to our premium coffee experience</p>
        </div>
        <div class="cart">
            Cart: <span id="cart-count">0</span> items
        </div>
        <div class="products" id="products">
            <!-- Products will be loaded here -->
        </div>
    </div>
    <script>
        let cart = [];
        const products = [
            { id: 1, name: 'Espresso', price: 2.50, description: 'Rich and bold espresso shot' },
            { id: 2, name: 'Cappuccino', price: 3.50, description: 'Espresso with steamed milk foam' },
            { id: 3, name: 'Latte', price: 4.00, description: 'Smooth espresso with steamed milk' },
            { id: 4, name: 'Americano', price: 3.00, description: 'Espresso with hot water' }
        ];

        function renderProducts() {
            const container = document.getElementById('products');
            container.innerHTML = products.map(product => `
                <div class="product">
                    <h3>${product.name}</h3>
                    <p>${product.description}</p>
                    <p><strong>$${product.price}</strong></p>
                    <button class="btn" onclick="addToCart(${product.id})">Add to Cart</button>
                </div>
            `).join('');
        }

        function addToCart(productId) {
            const product = products.find(p => p.id === productId);
            cart.push(product);
            document.getElementById('cart-count').textContent = cart.length;
            alert(`${product.name} added to cart!`);
        }

        renderProducts();
    </script>
</body>
</html>
EOF

# Clone application code
cd /opt
git clone https://github.com/31RahulPatel/three-tier-mongodbsetup.git
cd three-tier-mongodbsetup/application/frontend

# Build React app
npm install
npm run build

# Copy build to nginx
cp -r build/* /var/www/html/

# Get app server IP and update nginx config
APP_SERVER_IP=$(aws ec2 describe-instances --region us-west-2 --filters "Name=tag:Name,Values=*app*" "Name=instance-state-name,Values=running" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
sed -i "s/APP_SERVER_IP/$APP_SERVER_IP/g" /etc/nginx/nginx.conf

systemctl enable nginx
systemctl start nginx