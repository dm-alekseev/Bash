#!/bin/bash
sudo mkdir /etc/nginx/ssl
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout /etc/nginx/ssl/lab.local.key -out /etc/nginx/ssl/lab.local.crt  -subj "/C=BL/ST=Minsk/L=Minsk/O=Up4Lub/CN=lab.local/emailAddress=alekseev@stw.by"

