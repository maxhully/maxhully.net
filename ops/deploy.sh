#!/usr/bin/env bash

set -euxo pipefail

server_ssh=$1

hugo

rsync --progress --checksum ./conf/maxhully.net.conf "$server_ssh:/etc/nginx/sites-available/maxhully.net.conf"
rsync -avc --progress ./public/ root@servermax:/var/www/maxhully.net/

ssh -q -T "$server_ssh" <<EOL
    test -f /etc/nginx/sites-enabled/maxhully.net.conf ||
        ln -s /etc/nginx/sites-available/maxhully.net.conf /etc/nginx/sites-enabled/maxhully.net.conf
    test -f /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-enabled/default
    nginx -t && systemctl reload nginx
EOL
