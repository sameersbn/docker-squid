docker build -t docker-squid .
docker run --name squid --restart=always  -p 80:80 --publish 3128:3128 --volume $(pwd)/config:/etc/squid/ --volume /srv/docker/squid/cache:/var/spool/squid -v $(pwd)/logs:/var.log/squid -it docker-squid
