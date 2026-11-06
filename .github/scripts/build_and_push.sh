#!/bin/bash
set -euo pipefail

APPS=$1
REPO="ghcr.io/${GITHUB_REPOSITORY_OWNER}/containers"

# Convert the comma-separated string back into an array
IFS=',' read -ra apps <<< "$APPS"

for app in "${apps[@]}"; do
	[[ -n "$app" ]] || continue

	# Prefer explicit version from the Dockerfile, e.g. 'ARG version=1.2.3'
	version=$(sed -nE 's/^ARG[[:space:]]+version=["]?([^"[:space:]]+)["]?.*/\1/p' "$app/Dockerfile" | head -n1)

	if [[ -n "$version" ]]; then
		version="${version#v}"
		version="${version//+/-}"
	else
		# Fall back to a build timestamp, e.g. 20261106.1432
		version=$(date -u +%Y%m%d.%H%M)
	fi

	echo "Building and pushing $app (version $version)"
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		--tag "${REPO}:${app}" \
		--tag "${REPO}:${app}-${version}" \
		"$app"
done
