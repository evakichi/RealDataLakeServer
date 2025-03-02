#!/bin/bash

cd LDAP
if ! ./finalize.sh; then
	echo "err"
	exit 200
fi

cd ../keycloak
if ! ./finalize.sh; then
	echo "err"
	exit 201
fi

cd ../MinIO
if ! ./finalize.sh; then
	echo "err"
	exit 202
fi

cd ../pgsql
if ! ./finalize.sh; then
	echo "err"
	exit 203
fi

cd ../spark
if ! ./finalize.sh; then
	echo "err"
	exit 204
fi

cd ../admin-tool
if ! ./finalize.sh; then
	echo "err"
	exit 205
fi
