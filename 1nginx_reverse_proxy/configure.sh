#!/bin/bash

docker cp {UPDATED default.conf PARENT location}/default.conf proxy:/etc/nginx/conf.d/
docker exec proxy nginx -t
echo "Re-loading..."
docker exec proxy nginx -s reload
echo "Re-starting..."
service nginx restart