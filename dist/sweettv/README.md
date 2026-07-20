# SWEET.TV Manticore Image

This folder contains the reproducible build path for a patched Manticore image
used by the SWEET.TV Helm chart.

The image keeps the official runtime layout from `manticoresearch/manticore:28.4.4`
and replaces only `/usr/bin/searchd` with a binary compiled from this repository.

## Build Locally

```bash
dist/sweettv/build-searchd-overlay.sh
```

By default this builds and loads:

```text
ghcr.io/sweet-tv/manticoresearch:28.4.4-sweettv.1
```

for `linux/amd64`.

## Push To Registry

```bash
PUSH=1 PLATFORM=linux/amd64 \
IMAGE=ghcr.io/sweet-tv/manticoresearch:28.4.4-sweettv.1 \
dist/sweettv/build-searchd-overlay.sh
```

Multi-arch push:

```bash
PUSH=1 PLATFORM=linux/amd64,linux/arm64 \
IMAGE=ghcr.io/sweet-tv/manticoresearch:28.4.4-sweettv.1 \
dist/sweettv/build-searchd-overlay.sh
```

## Helm Usage

After pushing the image, build the Helm balancer and worker images from it:

```dockerfile
ARG MANTICORE_IMAGE=ghcr.io/sweet-tv/manticoresearch:28.4.4-sweettv.1
FROM ${MANTICORE_IMAGE}
```

Then release the chart and enable `balancer.config.agent.conn: pconn` in dev/stg.
