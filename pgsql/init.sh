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
SPARK_DB_NAME='${SPARK_DB_NAME}'
SPARK_DB_USERNAME='${SPARK_DB_NAME}'
SPARK_DB_PASSWORD='${SPARK_DB_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" conf/nginx.conf.org > conf/nginx.conf

if  ! sudo cp -r ../certs/ ./ ;then
	echo "copy certs err."
	exit 253;
fi

if  ! sudo chown 999:999 ./certs/* ; then
	echo "certs err"
	exit 252;
fi

COMPOSE_BAKE=true docker compose up -d --build

exit 0;
