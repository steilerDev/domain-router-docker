#!/bin/bash

function createRoute {
    echo "Creating route $1 from $2 to $3"

    export SOURCE_NAME=$2
    export TARGET_NAME=$3

    MYVARS='$SOURCE_NAME:$TARGET_NAME'

    envsubst "$MYVARS" <domain.conf.tmpl > /etc/nginx/conf.d/${1}.conf
}

echo "Welcome to Domain-Router by steilerDev - https://github.com/steilerDev/domain-router-docker -"

echo "Reading environment variables..."
compgen -A variable | grep -E "^ROUTER_" | while read line; do 
    NAME=$(echo $line | cut -c8- | tr '_' '.')

    # Split rule betwen source and destination
    IFS='=>' read -ra RULE <<< ${!line}
    DEST=$(echo ${RULE[2]} | tr -d ' ')

    index=1
    IFS=';' read -ra SOURCES <<< ${RULE[0]}
    for source in "${SOURCES[@]}"; do
        createRoute "${NAME}-${index}" $source $DEST
        index=$((index + 1))
    done
done

exec nginx -g 'daemon off;'