#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo yum install mod_ssl -y
sudo systemctl enable --now httpd.service