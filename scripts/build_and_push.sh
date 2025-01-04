#!/bin/bash
set -euo pipefail

APPS=$1

# Convert the comma-separated string back into an array
IFS=',' read -ra apps <<< "$APPS"

for app in "${apps[@]}"; do
	if [[ -n "$app" ]]; then
		echo "Building and pushing image for $app"
		docker buildx build \
			--platform linux/amd64,linux/arm64 \
			--push \
			--tag "ghcr.io/${GITHUB_REPOSITORY_OWNER}/containers:$app" \
			"$app"
	fi
done
