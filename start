#!/bin/bash
set -e

# deprecated: backward compatibility
if [[ -f /etc/squid3/squid.user.conf ]]; then
  rm -rf /etc/squid3/squid.conf
  ln -sf /etc/squid3/squid.user.conf /etc/squid3/squid.conf
fi

# fix permissions on the log dir
mkdir -p ${SQUID_LOG_DIR}
chmod -R 755 ${SQUID_LOG_DIR}
chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}

# fix permissions on the cache dir
mkdir -p ${SQUID_CACHE_DIR}
chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

# initialize the cache_dir
if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
  /usr/sbin/squid3 -N -f /etc/squid3/squid.conf -z
fi

exec /usr/sbin/squid3 -NYC -d 1 -f /etc/squid3/squid.conf
