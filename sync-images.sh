#!/usr/bin/env bash

set -e

TARGET_ACR="registry.cn-shanghai.aliyuncs.com"

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
  skopeo copy --all --retry-times 3 "$source" "$target"
  echo "<< sync $source to $target done"

done < sync-images.txt
