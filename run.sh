#!/bin/bash

DB_HOST=${DB_HOST:-database}
DB_NAME=${DB_NAME:-zabbix}
DB_USER=${DB_USER:-zabbix}
DB_PASSWORD=${DB_PASSWORD:-insecure}
DEBUG_LEVEL=${DEBUG_LEVEL:-2}

## Writing config for zabbix server
cat <<EOF > /etc/zabbix/zabbix_server.conf
AlertScriptsPath=/usr/lib/zabbix/alertscripts
DBHost=${DB_HOST}
DBName=${DB_NAME}
DBUser=${DB_USER}
DBPassword=${DB_PASSWORD}
DebugLevel=${DEBUG_LEVEL}
ExternalScripts=/usr/lib/zabbix/externalscripts
Fping6Location=/usr/bin/fping6
FpingLocation=/usr/bin/fping
LogType=console
PidFile=/dev/null
Timeout=10
EOF

MYSQL_OPTS="-h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD}"

echo -n "check if mysql reachable: "
for run in {1..10}; do
    mysqladmin ${MYSQL_OPTS} ping 2> /dev/null > /dev/null && echo "ok" && break
    echo -n .
    if [ $run -gt 5 ]; then
        echo "failed"
        mysqladmin ${MYSQL_OPTS} ping
        exit 1
    fi
    sleep 1
done

if ! mysql ${MYSQL_OPTS} ${DB_NAME} -e "SELECT 1 from users;"; then
    echo "Database needs initialization"
    zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql ${MYSQL_OPTS} ${DB_NAME}
fi

## starting zabbix server
exec chroot --userspec=zabbix:zabbix . /usr/sbin/zabbix_server -f