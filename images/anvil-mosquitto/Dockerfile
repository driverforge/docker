# Mosquitto MQTT broker with per-connection HTTP auth.
#
# Built on iegomez/mosquitto-go-auth so we get a Mosquitto binary and
# the auth plugin compiled against matched ABIs without having to
# build the plugin ourselves. The plugin delegates auth + ACL
# decisions to an HTTP backend configured at container start via the
# AUTH_BACKEND_* env vars — consumers point it at whatever service
# implements the mosquitto-go-auth HTTP protocol.
FROM iegomez/mosquitto-go-auth:latest

# entrypoint.sh substitutes env vars into the config with sed
# instead of envsubst so we don't have to install anything on top
# of the base image. The iegomez/mosquitto-go-auth base hasn't been
# rebuilt in a while and its apt sources point at Debian `stable`,
# which now resolves to trixie — any apt-get install tries to
# upgrade base-files across a release boundary and fails. sed is in
# every Debian base image by default, so rendering the config needs
# no additional packages and can't break on future Debian rolls.
USER root

COPY mosquitto.conf.template /mosquitto/config/mosquitto.conf.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 1883

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
