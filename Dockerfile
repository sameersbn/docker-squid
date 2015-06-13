FROM sameersbn/ubuntu:14.04.20150604
MAINTAINER sameer@damagehead.com

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/squid-ssl/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y squid3-ssl \
 && mv /etc/squid3/squid.conf /etc/squid3/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/* # 20150604

ADD squid.conf /etc/squid3/squid.conf

ADD start /start
RUN chmod 755 /start

EXPOSE 3128
VOLUME ["/var/spool/squid3"]

CMD ["/start"]
