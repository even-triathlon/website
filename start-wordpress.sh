#!/bin/bash
# https://stackoverflow.com/questions/74054932/how-to-install-and-setup-wordpress-using-podman

# Set environment variables:
POD_NAME='wordpress_mariadb'

DB_ROOT_PW='sup3rS3cr3t'
DB_NAME='wp'
DB_PASS='s0m3wh4tS3cr3t'
DB_USER='wordpress'

podman pod create --name $POD_NAME -p 8080:80

podman run \
-d --restart=always --pod=$POD_NAME \
-e MYSQL_ROOT_PASSWORD="$DB_ROOT_PW" \
-e MYSQL_DATABASE="$DB_NAME" \
-e MYSQL_USER="$DB_USER" \
-e MYSQL_PASSWORD="$DB_PASS" \
-v $HOME/public_html/wordpress/mysql:/var/lib/mysql:Z \
--name=wordpress-db docker.io/mariadb:latest

podman run \
-d --restart=always --pod=$POD_NAME \
-e WORDPRESS_DB_NAME="$DB_NAME" \
-e WORDPRESS_DB_USER="$DB_USER" \
-e WORDPRESS_DB_PASSWORD="$DB_PASS" \
-e WORDPRESS_DB_HOST="127.0.0.1" \
-v $HOME/public_html/wordpress/html:/var/www/html:Z \
--name wordpress docker.io/library/wordpress:latest
