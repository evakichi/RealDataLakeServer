#!/bin/bash

cd ../MinIO
docker compose down
docker volume rm minio_minio-volume

