#!/bin/bash

sudo docker cp /home/psychopunk_sage/Code/Lang/API/django/doc_vivenns/default.conf proxy:/etc/nginx/conf.d/
sudo docker exec proxy nginx -t
echo "Re-loading..."
sudo docker exec proxy nginx -s reload
echo "Re-starting..."
sudo service nginx restart