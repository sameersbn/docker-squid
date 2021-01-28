FROM centos:centos8
LABEL maintainer=StackHPC

ENV SQUID_VERSION=4.4 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

RUN dnf install -y \
    which \
    squid-${SQUID_VERSION}

COPY squid.conf /etc/squid/squid.conf
RUN chown root.squid /etc/squid/squid.conf
RUN chmod 0640 /etc/squid/squid.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 0755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
