#!/bin/bash
#
# Author: Duye Chen
#

if [ -z $3 ]
then
    echo "Usage: ./run.sh [DOMAIN_NAME] [CLOUDFLARE_API_KEY] [CLOUDFLARE_EMAIL]"
    exit
fi

DOMAIN_NAME=$1
PATH=$PATH

ABSOLUTE_FILENAME=`readlink -e "$0"`
DIR=`dirname "$ABSOLUTE_FILENAME"`

########## Modify THIS SECTION #############
# MODE="staging"
CERTBOT_EMAIL="exempl@gmail.com"
CLOUDFLARE_API_KEY=$2
CLOUDFLARE_EMAIL=$3
############################################

echo "dns_cloudflare_email = $CLOUDFLARE_EMAIL" >> "$DIR/cloudflare.ini"
echo "dns_cloudflare_api_key = $CLOUDFLARE_API_KEY" >> "$DIR/cloudflare.ini"
chmod 600 /cloudflare.ini

docker build -t wildcard-certbot "$DIR"

docker run -it --rm \
    -v "$DIR/conf:/etc/letsencrypt" \
    -e DOMAIN_NAME=$DOMAIN_NAME \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e CLOUDFLARE_API_KEY=$CLOUDFLARE_API_KEY \
    -e CLOUDFLARE_EMAIL=$CLOUDFLARE_EMAIL \
    -e MODE=$MODE \
    wildcard-certbot