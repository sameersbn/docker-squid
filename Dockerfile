FROM sameersbn/ubuntu:14.04.20150604
MAINTAINER sameer@damagehead.com

RUN apt-get update \
 && apt-get install -y squid3 \
 && mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/* # 20150604

ADD squid.conf /etc/squid3/squid.conf

ADD start /start
RUN chmod 755 /start

EXPOSE 3128
VOLUME ["/var/spool/squid3"]

CMD ["/start"]
