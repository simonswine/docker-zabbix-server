# Zabbix 3.0 Server for MySQL in docker

## Environment variables

Name | Default | Required | Description
--- | --- | --- | ---
`DB_HOST` | database | No |  Hostname of database server
`DB_NAME` | zabbix | No |  Name of database
`DB_USER` | zabbix | No |  User for database
`DB_PASSWORD` | insecure | No |  Password for database
`DEBUG_LEVEL` | 2 | No |  Debug level for zabbix daemon

## Usage

Requirements:

* [docker](https://docs.docker.com/engine/installation/)
* [docker-compose](https://docs.docker.com/compose/install/)

And then run the docker compose:

```
# clone this repository

# run inside the cloned directory
docker-compose up
```

