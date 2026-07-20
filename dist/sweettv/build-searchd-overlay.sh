#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

image="${IMAGE:-ghcr.io/sweet-tv/manticoresearch:28.4.4-sweettv.1}"
base_image="${BASE_IMAGE:-manticoresearch/manticore:28.4.4}"
builder_image="${BUILDER_IMAGE:-manticoresearch/external_toolchain:clang16_cmake3263}"
platform="${PLATFORM:-linux/amd64}"
push="${PUSH:-0}"
revision="$(git rev-parse HEAD)"

args=(
	docker buildx build
	--progress=plain
	--file dist/sweettv/Dockerfile.searchd-overlay
	--build-arg "BASE_IMAGE=${base_image}"
	--build-arg "BUILDER_IMAGE=${builder_image}"
	--build-arg "IMAGE_REVISION=${revision}"
	--platform "${platform}"
	--tag "${image}"
)

if [[ "${push}" == "1" ]]; then
	args+=(--push)
else
	if [[ "${platform}" == *,* ]]; then
		echo "Multi-platform builds cannot be loaded into the local Docker daemon. Set PUSH=1." >&2
		exit 1
	fi
	args+=(--load)
fi

args+=(.)

printf 'Building %s from %s for %s\n' "${image}" "${base_image}" "${platform}"
"${args[@]}"
