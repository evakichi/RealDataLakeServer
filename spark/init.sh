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
SPARK_CATALOG_NAME='${SPARK_CATALOG_NAME}'
SPARK_ENDPOINT_NAME='${SPARK_ENDPOINT_NAME}'
SPARK_DB_NAME='${SPARK_DB_NAME}'
SPARK_DB_USERNAME='${SPARK_DB_NAME}'
SPARK_DB_PASSWORD='${SPARK_DB_PASSWORD}'
SPARK_WAREHOUSE_NAME='${SPARK_WAREHOUSE_NAME}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" Dockerfile.org > Dockerfile
sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" conf/spark-defaults.conf.org > conf/spark-defaults.conf
sed "s/__SPARK_CATALOG_NAME__/${SPARK_CATALOG_NAME}/g" -i conf/spark-defaults.conf
sed "s/__SPARK_DB_USERNAME__/${SPARK_DB_USERNAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_DB_NAME__/${SPARK_DB_NAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_ENDPOINT_NAME__/${SPARK_ENDPOINT_NAME}/g" -i conf/spark-defaults.conf 
sed "s/__SPARK_WAREHOUSE_NAME__/${SPARK_WAREHOUSE_NAME}/g" -i conf/spark-defaults.conf 

echo "spark.sql.catalog."${SPARK_CATALOG_NAME}".jdbc.password     "${SPARK_DB_PASSWORD} >> conf/spark-defaults.conf

if  ! cp -r ../certs ./ ;then
	echo 'copy certs err.'
	exit 253;
fi

COMPOSE_BAKE=true docker compose up -d --build

exit 0;
