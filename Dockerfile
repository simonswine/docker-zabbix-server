FROM debian:jessie

ENV ZABBIX_VERSION 3.0
ENV ZABBIX_FULL_VERSION 1:3.0.1-1+jessie

# Add zabbix repo
COPY zabbix-repo.key /tmp/
RUN echo "deb http://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/debian jessie main"     >  /etc/apt/sources.list.d/zabbix.list && \
    echo "deb-src http://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/debian jessie main" >> /etc/apt/sources.list.d/zabbix.list && \
    apt-key add /tmp/zabbix-repo.key

# install zabbix-server
RUN apt-get update && \
    apt-get -y --no-install-recommends install "zabbix-server-mysql=${ZABBIX_FULL_VERSION}" snmpd snmptt

ADD run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]
