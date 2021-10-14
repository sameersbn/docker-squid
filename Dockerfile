FROM debian:bullseye-20210111-slim
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_VERSION=4.13-10 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=proxy

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
   squid-openssl=${SQUID_VERSION}* \
   ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN sed '/^#http_access allow localnet/s/^#//' -i /etc/squid/squid.conf \
  && mkdir -p /var/run/squid \
  && chown -R ${SQUID_USER}:${SQUID_USER} /var/run/squid

COPY conf.d/ /etc/squid/conf.d/
COPY entrypoint.sh /usr/sbin/entrypoint.sh

EXPOSE 3128/tcp
USER ${SQUID_USER}
ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
