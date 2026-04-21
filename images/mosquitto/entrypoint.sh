#!/bin/sh
#
# Render mosquitto.conf from the template, substituting env-provided
# values (auth backend location, shared secret), then exec mosquitto.
# Fails fast if any required variable is missing so we don't silently
# boot with a broken auth config.

set -eu

: "${AUTH_BACKEND_HOST:?AUTH_BACKEND_HOST must be set (hostname of the HTTP auth backend)}"
: "${MQTT_AUTH_HOOK_SECRET:?MQTT_AUTH_HOOK_SECRET must be set}"
: "${AUTH_BACKEND_PORT:=8080}"
: "${AUTH_BACKEND_PATH_PREFIX:=/api/mqtt/auth}"

export AUTH_BACKEND_HOST AUTH_BACKEND_PORT AUTH_BACKEND_PATH_PREFIX MQTT_AUTH_HOOK_SECRET

envsubst '${AUTH_BACKEND_HOST} ${AUTH_BACKEND_PORT} ${AUTH_BACKEND_PATH_PREFIX} ${MQTT_AUTH_HOOK_SECRET}' \
    < /mosquitto/config/mosquitto.conf.template \
    > /mosquitto/config/mosquitto.conf

exec mosquitto -c /mosquitto/config/mosquitto.conf
