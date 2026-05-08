# anvil-linux-node-24 — Driverforge's pinned Node 24 + Alpine base image.
#
# Every Driverforge Node service extends this instead of pulling
# node:24-alpine directly, so that when we bump anvil-linux-node-24 the
# whole fleet moves together and we never have subtle drift between
# services built at different times.
#
# Keep this image thin: only what every service needs.
FROM node:24.15.0-alpine

# Every service uses Yarn via corepack; lift the one-liner here so
# service Dockerfiles don't each repeat it.
RUN corepack enable
