#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
echo "<h1>Welcome to Terraform Auto-Scaling Web Server</h1>" | sudo tee /var/www/html/index.html
sudo systemctl start apache2
sudo systemctl enable apache2