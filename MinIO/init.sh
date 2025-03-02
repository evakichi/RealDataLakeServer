#!/bin/bash

if [ ! -f ../.env ];then
	echo "please spacify .env file."
	exit 255
fi

. ../.env 

if [ ! -f ../.password ]; then
	echo "cannot read ../.password"
	exit 254
fi

. ../.password

cat << EOF > .env
DOMAIN_NAME='${DOMAIN_NAME}'
MINIO_ROOT_USER='${MINIO_ROOT_USER}'
MINIO_ROOT_PASSWORD='${MINIO_ROOT_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" conf/nginx.conf.org > conf/nginx.conf

docker compose up -d --build

exit 0;
