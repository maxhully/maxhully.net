#!/usr/bin/env bash

# Here's some other stuff I did on the server:
#
#   apt-get install nginx
#   apt-get install logrotate
#   apt-get install certbot python3-certbot-nginx
#   certbot --nginx

set -euxo pipefail

server_ssh=$1

hugo

rsync ./conf/maxhully.net.conf "$server_ssh:/etc/nginx/sites-available/maxhully.net.conf"
rsync -avc --progress ./public/ root@servermax:/var/www/maxhully.net/

ssh -q -T "$server_ssh" <<EOL
    test -f /etc/nginx/sites-enabled/maxhully.net.conf ||
        ln -s /etc/nginx/sites-available/maxhully.net.conf /etc/nginx/sites-enabled/maxhully.net.conf
    test -f /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-enabled/default
    nginx -t && systemctl reload nginx
EOL
