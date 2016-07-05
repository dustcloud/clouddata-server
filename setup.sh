#!/bin/bash

# Update system timezone
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime

# Remove unused packages from original distribution
sudo apt-get remove -y puppet chef

# ----------------------------------------------------------------------
# Get up-to-date
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

# guest utils for VirtualBox are missing in 16.04
sudo apt-get install -y --no-install-recommends virtualbox-guest-utils

# Install required packages
sudo apt-get install -y openssh-server
sudo apt-get install -y python-pip
sudo apt-get install -y supervisor
sudo apt-get install -y curl
sudo apt-get install -y unzip
sudo apt-get install -y stunnel4
sudo apt-get install -y nginx

sudo systemctl enable supervisor.service

sudo pip install requests

# ----------------------------------------------------------------------
# Install and start InfluxDB

curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt-get update && sudo apt-get install -y influxdb

sudo systemctl daemon-reload
sudo systemctl unmask influxdb
sudo systemctl start influxdb
sudo systemctl enable influxdb.service

# configure the grafana database
influx -import -path=/vagrant/grafanadb.influx

# ----------------------------------------------------------------------
# Install and start grafana

curl -sL https://packagecloud.io/gpg.key | sudo apt-key add -
# grafana says use wheezy even for recent Ubuntu distributions
echo "deb https://packagecloud.io/grafana/stable/debian/ wheezy main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update && sudo apt-get install -y adduser libfontconfig grafana

sudo systemctl daemon-reload
sudo systemctl start grafana-server
#systemctl status grafana-server
sudo systemctl enable grafana-server.service

# ----------------------------------------------------------------------
# configure nginx

sudo cp /vagrant/clouddata_server.site.conf /etc/nginx/sites-available/clouddata_server.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/clouddata_server.conf /etc/nginx/sites-enabled/default

sudo nginx -s reload

# ----------------------------------------------------------------------
# configure clouddata_server

# clouddata_server requirements
sudo pip install influxdb
sudo pip install bottle

# note: clouddata_server.py comes from the SmartMeshSDK source
# http://dust-jenkins:8080/job/SmartMeshSDK/lastSuccessfulBuild/artifact/SmartMeshSDKTool/gen/SmartMeshSDK-1.0.7.140.zip

cp /vagrant/clouddata_server.py /home/ubuntu/clouddata_server.py

sudo cp /vagrant/clouddata_server.program.conf /etc/supervisor/conf.d/clouddata_server.conf
sudo systemctl restart supervisor

# ----------------------------------------------------------------------
# other configurations -- manually set up
# - update hostname to clouddata
# - grafana: configure influxdb data source
# - grafana: dashboard creation, set as default
# - grafana: enable anonymous access
# - iptables firewall
