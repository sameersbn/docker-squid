FROM sameersbn/debian:jessie.20140918
MAINTAINER sameer@damagehead.com

RUN apt-get update \
 && apt-get install -y squid3 \
 && rm -rf /var/lib/apt/lists/* # 20140928

ADD squid.conf /etc/squid3/squid.conf

ADD start /start
RUN chmod 755 /start

EXPOSE 3128
VOLUME ["/var/spool/squid3"]

CMD ["/start"]
