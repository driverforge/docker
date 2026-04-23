#!/bin/sh
#
# Render mosquitto.conf from the template, substituting env-provided
# values for the HTTP auth backend location, then exec mosquitto.
# Fails fast if a required variable is missing so we don't silently
# boot with a broken auth config.

set -eu

: "${AUTH_BACKEND_HOST:?AUTH_BACKEND_HOST must be set (hostname of the HTTP auth backend)}"
: "${AUTH_BACKEND_PORT:=8080}"
: "${AUTH_BACKEND_PATH_PREFIX:=/api/mqtt/auth}"

# Substitute with sed so the image doesn't depend on envsubst (see
# Dockerfile for why — apt is unusable on the base image). Values
# are escaped so &, \, and | can't break the replacement. Delimiter
# is | so path-prefix values containing / work without escaping.
escape() {
    printf '%s' "$1" | sed -e 's/[&\\|]/\\&/g'
}

sed \
    -e "s|\${AUTH_BACKEND_HOST}|$(escape "$AUTH_BACKEND_HOST")|g" \
    -e "s|\${AUTH_BACKEND_PORT}|$(escape "$AUTH_BACKEND_PORT")|g" \
    -e "s|\${AUTH_BACKEND_PATH_PREFIX}|$(escape "$AUTH_BACKEND_PATH_PREFIX")|g" \
    /mosquitto/config/mosquitto.conf.template \
    > /mosquitto/config/mosquitto.conf

exec mosquitto -c /mosquitto/config/mosquitto.conf
