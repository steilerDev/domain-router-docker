#!/bin/bash

TMPL_FILE="/opt/domain-router/domain.conf.tmpl"
NGINX_CONF="/etc/nginx/conf.d"

function createRoute {
    echo "  - Creating route $1 from $2 to $3"

    export SOURCE_NAME=$2
    export TARGET_NAME=$3

    MYVARS='$SOURCE_NAME:$TARGET_NAME'

    envsubst "$MYVARS" <$TMPL_FILE > $NGINX_CONF/${1}.conf
}

echo 
echo "Welcome to Domain-Router by steilerDev - https://github.com/steilerDev/domain-router-docker -"
echo 
echo "Reading environment variables & defining routes..."
compgen -A variable | grep -E "^ROUTER_" | while read line; do 
    NAME=$(echo $line | cut -c8- | tr '_' '.')

    # Split rule betwen source and destination
    IFS='=>' read -ra RULE <<< ${!line}
    DEST=$(echo ${RULE[2]} | tr -d ' ')

    index=1
    IFS=';' read -ra SOURCES <<< ${RULE[0]}
    for source in "${SOURCES[@]}"; do
        createRoute "${NAME}-${index}" $source $DEST
        export HOSTS+=",$source"
        echo $HOSTS
        index=$((index + 1))
    done
done
echo $HOSTS
export VIRTUAL_HOST=${HOSTS:1}
export LETSENCRYPT_HOST=${HOSTS:1}
export VIRTUAL_PORT=80

echo "Routes configured!"
echo 

echo "Listening for the following hosts:"
echo "  VIRTUAL_HOST: $VIRTUAL_HOST"
echo "  LETSENCRYPT_HOST: $LETSENCRYPT_HOST"
echo "  VIRTUAL_PORT: $VIRTUAL_PORT"