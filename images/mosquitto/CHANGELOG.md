# mosquitto

## 1.0.0

- Initial release. Built on `iegomez/mosquitto-go-auth:latest`.
- HTTP auth backend pointed at driverforge/graph `/api/mqtt/auth/*`.
- envsubst-driven config (`GRAPH_HOST`, `GRAPH_PORT`,
  `MQTT_AUTH_HOOK_SECRET`).
