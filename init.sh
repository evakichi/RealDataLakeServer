#!/bin/bash

if [ ! -f ./.env ];then
	echo "please spacify .env file."
	exit 255
fi

. .env 

if [ -f ./.password ]; then
	. ./.password
else
cat << EOF > ./.password
LDAP_ADMIN_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
LDAP_READONLY_USER_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
LAM_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
MINIO_ROOT_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
KEYCLOAK_DB_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
KEYCLOAK_ADMIN_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
SPARK_DB_PASSWORD='$(pwgen -1 -c -B -y -n -r "\$&;:><*\"\'\` \\" 32)'
EOF
. ./.password
fi

cat << EOF > LDAP/.env
DOMAIN_NAME=${DOMAIN_NAME}

LDAP_ORGANISATION=${LDAP_ORGANISATION}
LDAP_DOMAIN=${LDAP_DOMAIN}
LDAP_BASE_DN=${LDAP_BASE_DN}
LDAP_ADMIN_PASSWORD='${LDAP_ADMIN_PASSWORD}'
LDAP_READONLY_USER_PASSWORD='${LDAP_READONLY_USER_PASSWORD}'
LAM_PASSWORD='${LAM_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" LDAP/conf/nginx.conf.org > LDAP/conf/nginx.conf

cat << EOF > MinIO/.env
DOMAIN_NAME=${DOMAIN_NAME}
MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD='${MINIO_ROOT_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" MinIO/conf/nginx.conf.org > MinIO/conf/nginx.conf

cat << EOF > keycloak/.env 
DOMAIN_NAME=${DOMAIN_NAME}
KEYCLOAK_DB_USERNAME=${KEYCLOAK_DB_USERNAME}
KEYCLOAK_DB_PASSWORD='${KEYCLOAK_DB_PASSWORD}'
KEYCLOAK_ADMIN=${KEYCLOAK_ADMIN}
KEYCLOAK_ADMIN_PASSWORD='${KEYCLOAK_ADMIN_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" keycloak/kc.sh.org > keycloak/kc.sh
chmod 755 keycloak/kc.sh

if ! cp -r certs spark/ ; then
	echo No such directory certs
fi

cat << EOF > spark/.env
DOMAIN_NAME=${DOMAIN_NAME}
MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD='${MINIO_ROOT_PASSWORD}'
SPARK_CATALOG_NAME=${SPARK_CATALOG_NAME}
SPARK_ENDPOINT_NAME=${SPARK_ENDPOINT_NAME}
SPARK_DB_NAME=${SPARK_DB_NAME}
SPARK_DB_USERNAME=${SPARK_DB_NAME}
SPARK_DB_PASSWORD='${SPARK_DB_PASSWORD}'
SPARK_WAREHOUSE_NAME=${SPARK_WAREHOUSE_NAME}
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" spark/Dockerfile.org > spark/Dockerfile
sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" spark/conf/spark-defaults.conf.org > spark/conf/spark-defaults.conf
sed "s/__SPARK_CATALOG_NAME__/${SPARK_CATALOG_NAME}/g" -i spark/conf/spark-defaults.conf
sed "s/__SPARK_DB_USERNAME__/${SPARK_DB_USERNAME}/g" -i spark/conf/spark-defaults.conf 
sed "s/__SPARK_DB_NAME__/${SPARK_DB_NAME}/g" -i spark/conf/spark-defaults.conf 
sed "s/__SPARK_ENDPOINT_NAME__/${SPARK_ENDPOINT_NAME}/g" -i spark/conf/spark-defaults.conf 
sed "s/__SPARK_WAREHOUSE_NAME__/${SPARK_WAREHOUSE_NAME}/g" -i spark/conf/spark-defaults.conf 

echo "spark.sql.catalog."${SPARK_CATALOG_NAME}".jdbc.password     "${SPARK_DB_PASSWORD} >> spark/conf/spark-defaults.conf

cat << EOF > admin-tool/.env
DOMAIN_NAME=${DOMAIN_NAME}

LDAP_ORGANISATION=${LDAP_ORGANISATION}
LDAP_DOMAIN=${LDAP_DOMAIN}
LDAP_BASE_DN=${LDAP_BASE_DN}
LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD}
LDAP_READONLY_USER_PASSWORD=${LDAP_READONLY_USER_PASSWORD}
LAM_PASSWORD=${LAM_PASSWORD}

MINIO_ROOT_USER=${MINIO_ROOT_USER}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD}

KEYCLOAK_DB_USERNAME=${KEYCLOAK_DB_USERNAME}
KEYCLOAK_DB_PASSWORD=${KEYCLOAK_DB_PASSWORD}
KEYCLOAK_ADMIN=${KEYCLOAK_ADMIN}
KEYCLOAK_ADMIN_PASSWORD=${KEYCLOAK_ADMIN_PASSWORD}

SPARK_CATALOG_NAME=${SPARK_CATALOG_NAME}
SPARK_DB_NAME=${SPARK_DB_NAME}
SPARK_DB_USERNAME=${SPARK_DB_NAME}
SPARK_DB_PASSWORD=${SPARK_DB_PASSWORD}
EOF

cd LDAP
docker compose up -d --build

cd ../keycloak
docker compose up -d --build

cd ../MinIO
docker compose up -d --build

cd ../spark
COMPOSE_BAKE=true docker compose up -d --build

cd ../admin-tool
COMPOSE_BAKE=true docker compose up -d --build
exit 0;
