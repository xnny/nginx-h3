# nginx-h3
nginx with quic + http/3

### Test
```
$ sudo docker run --name nginx-h3 \
    --network host \
    --restart always \
    --volume /home/ubuntu/container/nginx/sites:/etc/nginx/sites-enabled:ro \
    --volume /home/ubuntu/container/nginx/ssl:/etc/nginx/ssl:ro \
    --volume /home/ubuntu/container/nginx/log:/var/log/nginx:rw \
    --volume /home/ubuntu/container/www:/var/www:ro \
    -d xnny/nginx-http3:latest
```