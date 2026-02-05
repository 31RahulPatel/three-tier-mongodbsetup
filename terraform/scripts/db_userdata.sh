#!/bin/bash
yum update -y

# Create MongoDB repository
cat > /etc/yum.repos.d/mongodb-org-7.0.repo << 'EOF'
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF

# Install MongoDB
yum install -y mongodb-org

# Create MongoDB data directory
mkdir -p /data/db
chown -R mongod:mongod /data/db

# Configure MongoDB
cat > /etc/mongod.conf << 'EOF'
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# Where and how to store data.
storage:
  dbPath: /var/lib/mongo
  journal:
    enabled: true

# how the process runs
processManagement:
  fork: true  # fork and run in background
  pidFilePath: /var/run/mongodb/mongod.pid  # location of pidfile
  timeZoneInfo: /usr/share/zoneinfo

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.

# security
security:
  authorization: disabled

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options

#auditLog:

#snmp:
EOF

# Set proper permissions
chown mongod:mongod /etc/mongod.conf
chown -R mongod:mongod /var/lib/mongo
chown -R mongod:mongod /var/log/mongodb

# Enable and start MongoDB
systemctl enable mongod
systemctl start mongod

# Wait for MongoDB to start
sleep 10

# Create initial database and collections
mongo << 'EOF'
use coffeeshop
db.createCollection("users")
db.createCollection("products")
db.createCollection("carts")
db.createCollection("orders")

// Create indexes
db.users.createIndex({ "email": 1 }, { unique: true })
db.users.createIndex({ "username": 1 }, { unique: true })
db.products.createIndex({ "name": 1 })
db.carts.createIndex({ "userId": 1 })

print("Database initialized successfully")
EOF

# Create backup script
cat > /opt/mongodb-backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/mongodb-backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

mongodump --out $BACKUP_DIR/backup_$DATE

# Keep only last 7 days of backups
find $BACKUP_DIR -type d -name "backup_*" -mtime +7 -exec rm -rf {} \;
EOF

chmod +x /opt/mongodb-backup.sh

# Add backup to crontab
echo "0 2 * * * /opt/mongodb-backup.sh" | crontab -

echo "MongoDB installation and configuration completed"