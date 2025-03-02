#!/bin/bash

docker compose down 
docker volume rm keycloak_keycloak-db-store
docker volume rm keycloak_keycloak-volume
