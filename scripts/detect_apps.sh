#!/bin/bash
set -euo pipefail

MANUAL_APPS=$1
BEFORE_REF=$2
CURRENT_SHA=$3
OUTPUT_FILE="apps_to_build"

# Ensure a clean output file
: > "$OUTPUT_FILE"

if [[ -n "$MANUAL_APPS" ]]; then
	echo "Manual trigger detected. Building specified apps."
	IFS=',' read -ra apps <<< "$MANUAL_APPS"
	for app in "${apps[@]}"; do
		echo "$app" >> "$OUTPUT_FILE"
	done
else
	# Automatic trigger: Detect changed Dockerfiles
	if [[ -z "$BEFORE_REF" ]]; then
		BEFORE_REF="HEAD~1"
	fi
	changed_files=$(git diff --name-only "$BEFORE_REF" "$CURRENT_SHA" | grep '.*/Dockerfile' || true)
	if [[ -n "$changed_files" ]]; then
		for file in $changed_files; do
			app=$(basename "$(dirname "$file")")
			echo "$app" >> "$OUTPUT_FILE"
		done
	fi
fi

# Handle cases where no apps are detected
if [[ ! -s "$OUTPUT_FILE" ]]; then
	echo "No apps detected." > "$OUTPUT_FILE"
fi

# Join detected apps into a single comma-separated string
apps=()
while IFS= read -r app; do
	apps+=("$app")
done < "$OUTPUT_FILE"
joined_apps=$(
	IFS=','
	echo "${apps[*]}"
)

# Export apps_to_build for the workflow
echo "apps_to_build=$joined_apps" >> "$GITHUB_OUTPUT"
