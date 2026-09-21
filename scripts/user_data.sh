#!/bin/bash
# Scripts run automatically as the 'root' user on boot.

# Update the package index
apt-get update -y

# Install Apache
apt-get install -y apache2

# Start and enable the service so it survives reboots
systemctl start apache2
systemctl enable apache2