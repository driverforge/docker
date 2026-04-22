# Mosquitto MQTT broker with per-connection HTTP auth.
#
# Built on iegomez/mosquitto-go-auth so we get a Mosquitto binary and
# the auth plugin compiled against matched ABIs without having to
# build the plugin ourselves. The plugin delegates auth + ACL
# decisions to an HTTP backend configured at container start via the
# AUTH_BACKEND_* env vars — consumers point it at whatever service
# implements the mosquitto-go-auth HTTP protocol.
FROM iegomez/mosquitto-go-auth:latest

# envsubst lets entrypoint.sh inject runtime values (backend host,
# path, shared secret) into the config without an external templater.
# The base image is Debian-based, so envsubst comes from gettext-base.
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY mosquitto.conf.template /mosquitto/config/mosquitto.conf.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 1883

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
