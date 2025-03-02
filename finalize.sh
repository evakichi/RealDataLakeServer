#!/bin/bash

cd LDAP
docker compose down
docker volume rm ldap_ldap-config
docker volume rm ldap_ldap-data

cd ../keycloak
docker compose down 
docker volume rm keycloak_keycloak-db-store
docker volume rm keycloak_keycloak-volume

cd ../MinIO
docker compose down
docker volume rm minio_minio-volume

cd ../pgsql
docker compose down 
docker volume rm pgsql_pgsql-store

cd ../spark
docker compose down 

cd ../admin-tool
docker compose down 
