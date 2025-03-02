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

cd pgsql/
if ! ./init.sh;then
	exit 200
fi

cd ../spark/
if ! ./init.sh;then
	exit 201
fi

cd ../LDAP/
if ! ./init.sh;then
	exit 202
fi

cd ../keycloak/
if ! ./init.sh;then
	exit 203
fi

cd ../MinIO/
if ! ./init.sh;then
	exit 204
fi

cd ../admin-tool/
if ! ./init.sh;then
	exit 205
fi

exit 0;
