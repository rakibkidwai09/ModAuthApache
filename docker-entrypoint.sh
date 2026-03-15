#!/bin/bash
set -e

# Load environment variables from config file
if [ -f /etc/apache2/oidc.env ]; then
    export $(grep -v '^#' /etc/apache2/oidc.env | xargs)
fi

# Replace placeholders in oidc.conf.template
envsubst < /usr/local/apache2/conf/extra/oidc.conf.template > /usr/local/apache2/conf/extra/oidc.conf

# Start Apache
exec "$@"