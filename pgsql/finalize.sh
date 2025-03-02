#!/bin/bash

cd ../pgsql
docker compose down 
docker volume rm pgsql_pgsql-store
