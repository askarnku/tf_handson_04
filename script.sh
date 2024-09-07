#!/bin/bash

yum update

yum install httpd -y

systemctl start httpd

systemctl enable httpd