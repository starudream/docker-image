#!/usr/bin/env bash

set -e

TARGET_ACR="registry.cn-shanghai.aliyuncs.com"
SKOPEO_PATH=${SKOPEO_PATH:-}

if [[ -z "$SKOPEO_PATH" ]]; then
  echo ">> SKOPEO_PATH not found, skip sync"
else
  version=$($SKOPEO_PATH --version)
  echo ">> SKOPEO_PATH: $SKOPEO_PATH, version: $version"
fi

while IFS= read -r image || [ -n "$image" ]; do

  if [[ -z "$image" || "$image" =~ ^# ]]; then
    continue
  fi

  source="docker://$image"

  if [[ "$image" =~ ^ghcr.io/ ]]; then
    image="${image#ghcr.io/}"
  fi

  if [[ "$image" =~ ^starudream/ ]]; then
    image="${image#starudream/}"
  fi

  target="docker://$TARGET_ACR/starudream/${image//\//_}"

  echo ">> sync $source to $target"

  if [[ -n "$SKOPEO_PATH" ]]; then
    $SKOPEO_PATH copy --all --retry-times 3 "$source" "$target"
    echo "<< sync $source to $target done"
  fi

done < sync-images.txt
