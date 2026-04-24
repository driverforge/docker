# anvil-mosquitto

## 1.0.1

- Remove the `auth_opt_http_headers X-Hook-Secret=…` line and the
  `MQTT_AUTH_HOOK_SECRET` env var from the entrypoint. The upstream
  `mosquitto-go-auth` plugin's HTTP backend sets only `Content-Type`
  and `User-Agent` on outbound requests, so custom header options are
  silently ignored — the secret was never actually transmitted. Auth
  of the broker to the backend must be done at the network layer.

## 1.0.0

- Initial release. Built on `iegomez/mosquitto-go-auth`.
- Auth backend configurable at runtime via `AUTH_BACKEND_HOST`,
  `AUTH_BACKEND_PORT`, and `AUTH_BACKEND_PATH_PREFIX` — consumers
  point the broker at whatever service implements the mosquitto-go-auth
  HTTP protocol.
- Shared-secret header rendered from `MQTT_AUTH_HOOK_SECRET` at
  container start.
