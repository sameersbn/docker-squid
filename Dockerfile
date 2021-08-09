FROM alpine:3.14
LABEL maintainer=StackHPC

COPY init /init
RUN apk update && apk upgrade && \
    apk add dumb-init && \
    apk add ca-certificates && \
    apk add --no-cache 'squid<5.1' && \
    rm -rf /var/cache/apk/* /tmp/* && \
    mkdir -p /defaults/squid && \
    mv /etc/squid/squid.conf* /defaults/squid/ && \
    chmod +x /init


ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/init"]
