# mosquitto — Driverforge MQTT broker with per-connection JWT auth.
#
# Built on iegomez/mosquitto-go-auth so we get a Mosquitto binary and
# plugin compiled against matched ABIs without having to build the
# plugin ourselves. The plugin delegates every auth decision to
# driverforge/graph's /api/mqtt/auth/* endpoints, which validate the
# JWT in the MQTT password and enforce clientID-prefix + topic ACL
# matching against the JWT sub (see DF-237).
FROM iegomez/mosquitto-go-auth:latest

# envsubst lets entrypoint.sh inject runtime values (graph host, shared
# secret) into the config without an external templater.
USER root
RUN apk add --no-cache gettext

COPY mosquitto.conf.template /mosquitto/config/mosquitto.conf.template
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 1883

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
