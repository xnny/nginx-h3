# nginx-h3
nginx with quic + http/3

### Test
```
$ sudo docker run --name nginx-h3 \
	--restart always \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443/tcp \
	--publish 0.0.0.0:443:443/udp \
	--volume /home/ubuntu/container/nginx/sites:/etc/nginx/sites-enabled:ro \
	--volume /home/ubuntu/container/nginx/ssl:/etc/nginx/ssl:ro \
	--volume /home/ubuntu/container/nginx/www:/var/www:ro \
	--volume /home/ubuntu/container/nginx/log:/var/log/nginx:rw \
	-d xnny/nginx-http3:latest
```