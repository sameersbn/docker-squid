#!/bin/bash
set -e

CACHE_MAX_SIZE=${CACHE_MAX_SIZE:-100}
CACHE_MAX_OBJECT_SIZE=${CACHE_MAX_OBJECT_SIZE:-4}
CACHE_MAX_MEM=${CACHE_MAX_MEM:-256}

OVERALL_SPEED_KBPS=${OVERALL_SPEED_KBPS:--1}
if [ ${OVERALL_SPEED_KBPS} -gt 0 ]; then
  OVERALL_SPEED_KBPS=$((${OVERALL_SPEED_KBPS} * 1000  / 8))
fi

INDIVIDUAL_SPEED_KBPS=${INDIVIDUAL_SPEED_KBPS:--1}
if [ ${INDIVIDUAL_SPEED_KBPS} -gt 0 ]; then
  INDIVIDUAL_SPEED_KBPS=$((${INDIVIDUAL_SPEED_KBPS} * 1000  / 8))
fi

# import user config if it exists
if [ -f /etc/squid3/squid.user.conf ]; then
  cp /etc/squid3/squid.user.conf /etc/squid3/squid.conf
fi

# apply squid config
sed 's/{{CACHE_MAX_SIZE}}/'"${CACHE_MAX_SIZE}"'/' -i /etc/squid3/squid.conf
sed 's/{{CACHE_MAX_OBJECT_SIZE}}/'"${CACHE_MAX_OBJECT_SIZE}"'/' -i /etc/squid3/squid.conf
sed 's/{{CACHE_MAX_MEM}}/'"${CACHE_MAX_MEM}"'/' -i /etc/squid3/squid.conf

sed 's/{{INDIVIDUAL_SPEED_KBPS}}/'"${INDIVIDUAL_SPEED_KBPS}"'/g' -i /etc/squid3/squid.conf
sed 's/{{OVERALL_SPEED_KBPS}}/'"${OVERALL_SPEED_KBPS}"'/g' -i /etc/squid3/squid.conf

# fix permissions on the log dir
sudo -u proxy -H mkdir -p /var/log/squid3
chmod -R 755 /var/log/squid3
chown -R proxy:proxy /var/log/squid3

# fix permissions on the cache dir
sudo -u proxy -H mkdir -p /var/spool/squid3
chown -R proxy:proxy /var/spool/squid3

# initialize the cache_dir
if [ ! -d /var/spool/squid3/00 ]; then
  /usr/sbin/squid3 -N -f /etc/squid3/squid.conf -z
fi

exec /usr/sbin/squid3 -NYC -d 1 -f /etc/squid3/squid.conf
