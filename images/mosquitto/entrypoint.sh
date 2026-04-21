#!/bin/sh
#
# Render mosquitto.conf from the template, substituting env-provided values
# (graph host, shared secret), then exec mosquitto. Fails fast if any
# required variable is missing so we don't silently boot with a broken
# auth config.

set -eu

: "${GRAPH_HOST:?GRAPH_HOST must be set (graph service hostname)}"
: "${MQTT_AUTH_HOOK_SECRET:?MQTT_AUTH_HOOK_SECRET must be set}"
: "${GRAPH_PORT:=8080}"

export GRAPH_HOST GRAPH_PORT MQTT_AUTH_HOOK_SECRET

envsubst '${GRAPH_HOST} ${GRAPH_PORT} ${MQTT_AUTH_HOOK_SECRET}' \
    < /mosquitto/config/mosquitto.conf.template \
    > /mosquitto/config/mosquitto.conf

exec mosquitto -c /mosquitto/config/mosquitto.conf
