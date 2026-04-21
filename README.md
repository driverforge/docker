# driverforge/docker

Public home for Driverforge's infrastructure and CI base images. Anything
in this repo is MIT-licensed and ships to `ghcr.io/driverforge/<image>`.

This repo is deliberately separate from the Driverforge application
monorepo so there's no ambient risk of accidentally publishing
proprietary code or configuration alongside public base images. Repo
visibility == image visibility.

## What lives here

| Image | Purpose |
|-------|---------|
| `anvil-linux-node` | Thin wrapper over `node:22-alpine` with `corepack enable`. Every Driverforge Node service extends this so every service sits on a pinned, known-digest base. |
| `mosquitto` | Mosquitto MQTT broker built on `iegomez/mosquitto-go-auth`. Used by Driverforge for per-connection JWT auth (see DF-237). |

Application images (graph, anvil-ingestion, etc.) are **not** published
here. They build on top of `anvil-linux-node` and live in the private
Driverforge container registry because they contain proprietary code.

## Versioning

Every image has an `images/<name>/VERSION` file holding a SemVer string
(`1.2.3`). Tags on the registry are:

- `ghcr.io/driverforge/<name>:{VERSION}` — immutable, pinned by consumers
- `ghcr.io/driverforge/<name>:latest` — floating, only for manual `docker
  pull` exploration. Do **not** reference `:latest` from
  `dev-deps.yml`, from a k8s manifest, or from a service Dockerfile.
  Always pin to an explicit version.

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

1. Create `images/<name>/` with at minimum `Dockerfile`, `VERSION` (`1.0.0`),
   and `CHANGELOG.md`.
2. Add the image name to the matrix in `.github/workflows/publish.yml`
   and `.github/workflows/pr-checks.yml`.
3. Open a PR. On merge, the initial `1.0.0` tag is published.

## Registry

Public ghcr.io. No authentication required to pull. CI uses the
auto-provisioned `GITHUB_TOKEN` to push.

## Policy

- **No commits directly to `main`.** Everything goes through a PR.
- **No Claude / AI attribution** in commits or PR descriptions.
