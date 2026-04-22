# mosquitto

## 1.0.1

- Install `envsubst` via `apt-get` (`gettext-base`) instead of `apk`.
  The `iegomez/mosquitto-go-auth` base image is Debian-based, so the
  Alpine-assumption in 1.0.0 prevented the image from ever building.

## 1.0.0

- Initial release. Built on `iegomez/mosquitto-go-auth`.
- Auth backend configurable at runtime via `AUTH_BACKEND_HOST`,
  `AUTH_BACKEND_PORT`, and `AUTH_BACKEND_PATH_PREFIX` — consumers
  point the broker at whatever service implements the mosquitto-go-auth
  HTTP protocol.
- Shared-secret header rendered from `MQTT_AUTH_HOOK_SECRET` at
  container start.
