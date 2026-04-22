# driverforge/docker

Public home for infrastructure and CI base images. Everything here is
MIT-licensed and ships to `ghcr.io/driverforge/<image>`.

## What lives here

| Image | Purpose |
|-------|---------|
| `anvil-linux-node` | Thin wrapper over `node:22-alpine` with `corepack enable`. Meant as a shared base for Node services so every consumer sits on a pinned, known-digest image instead of floating `node:22-alpine` drifting underneath future rebuilds. |
| `anvil-mosquitto` | Mosquitto MQTT broker pre-built with the `mosquitto-go-auth` HTTP-callback plugin. Configured at runtime via env vars pointing at any compliant HTTP auth backend. |

Application-level images are not published here; they live in a
private container registry.

## Versioning

Every image has an `images/<name>/VERSION` file holding a SemVer string
(`1.2.3`). Tags on the registry are:

- `ghcr.io/driverforge/<name>:{VERSION}` — immutable, pinned by consumers
- `ghcr.io/driverforge/<name>:latest` — floating, only for manual
  `docker pull` exploration. Don't reference `:latest` from production
  configs or CI. Always pin to an explicit version.

### Bumping a version

1. Open a PR. Edit `images/<name>/Dockerfile` (or any sibling file) and
   bump `images/<name>/VERSION`.
2. Update `images/<name>/CHANGELOG.md` with a one-liner describing the
   change.
3. The PR CI will fail if any file under `images/<name>/` changed
   without a VERSION bump, or if the new VERSION isn't a valid SemVer
   strictly greater than the one on `main`.
4. On merge to `main`, the publish workflow builds and pushes
   `{VERSION}` and `:latest` to ghcr.io. If the tag already exists
   the publish fails — tags are immutable.

### Bump semantics

| Change | Bump |
|--------|------|
| Upstream patch only (e.g. new `node:22-alpine` picking up a CVE fix) | PATCH |
| Added a package, new env var, or non-breaking tool | MINOR |
| Removed a package, changed CMD/ENTRYPOINT, changed default config in a way that breaks consumers | MAJOR |

## Adding a new image

1. Create `images/<name>/` with at minimum `Dockerfile`, `VERSION`
   (`1.0.0`), and `CHANGELOG.md`.
2. Open a PR. On merge, the initial `1.0.0` tag is published.

## Registry

Public ghcr.io. No authentication required to pull. CI uses the
auto-provisioned `GITHUB_TOKEN` to push.

## Policy

- **No commits directly to `main`.** Everything goes through a PR.
