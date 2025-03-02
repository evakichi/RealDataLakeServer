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

LDAP_ORGANISATION='${LDAP_ORGANISATION}'
LDAP_DOMAIN='${LDAP_DOMAIN}'
LDAP_BASE_DN='${LDAP_BASE_DN}'
LDAP_ADMIN_PASSWORD='${LDAP_ADMIN_PASSWORD}'
LDAP_READONLY_USER_PASSWORD='${LDAP_READONLY_USER_PASSWORD}'
LAM_PASSWORD='${LAM_PASSWORD}'
EOF

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" conf/nginx.conf.org > conf/nginx.conf

docker compose up -d --build

exit 0;
