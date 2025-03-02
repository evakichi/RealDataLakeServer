#!/bin/bash

docker compose down
docker volume rm ldap_ldap-config
docker volume rm ldap_ldap-data
