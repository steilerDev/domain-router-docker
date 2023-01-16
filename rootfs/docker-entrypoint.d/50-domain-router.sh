#!/bin/bash

TMPL_FILE="/opt/domain-router/domain.conf.tmpl"
NGINX_CONF="/etc/nginx/conf.d"
DOMAINS_FILE="$(mktemp)"
ENV_TMPL_FILE="/opt/domain-router/domains.env.tmpl"
ENV_FILE="/opt/domain-router/domains.env"

function createRoute {
    echo "  - Creating route $1 from $2 to $3"

    if [[ "$VIRTUAL_HOST" != *"$2"* ]]; then
        echo "WARN: $2 not present in VIRTUAL_HOST definition - route might not work"
    fi

    if [[ "$LETSENCRYPT_HOST" != *"$2"* ]]; then
        echo "WARN: $2 not present in LETSENCRYPT definition - route might not work"
    fi

    export SOURCE_NAME=$2
    export TARGET_NAME=$3
    MYVARS='$SOURCE_NAME:$TARGET_NAME'
    envsubst "$MYVARS" <$TMPL_FILE > $NGINX_CONF/${1}.conf

    # Collecting domains that we need to listen to/get certs for
    if [ -s $DOMAINS_FILE ]; then
        echo -n "," >> $DOMAINS_FILE
    fi
    echo -n $SOURCE_NAME >> $DOMAINS_FILE
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
    IFS=',' read -ra SOURCES <<< ${RULE[0]}
    for source in "${SOURCES[@]}"; do
        createRoute "${NAME}-${index}" $source $DEST
        index=$((index + 1))
    done
done

DOMAINS=$(cat $DOMAINS_FILE)

echo "Routes loaded!"
echo "In order to remove warnings, add the following env-variables to your docker compose configuration:"
echo "  VIRTUAL_HOST: $DOMAINS"
echo "  LETSENCRYPT_HOST: $DOMAINS"
echo