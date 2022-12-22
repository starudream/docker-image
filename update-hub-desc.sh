#!/usr/bin/env bash

set -e

DOCKER_API="https://hub.docker.com/v2"
DOCKER_REGISTRY="registry-1.docker.io"
DOCKER_REQUEST_HEADER="Content-Type: application/json"

REPOSITORY=$1
if [ -z "${REPOSITORY}" ]; then
  echo "Missing parameters, example: './update-hub-readme.sh starudream/alpine'."
  exit 1
fi

DEFAULT_README="
# ${REPOSITORY}

![Docker](https://img.shields.io/github/actions/workflow/status/starudream/docker-image/docker.yml?label=docker&style=for-the-badge)
![License](https://img.shields.io/github/license/starudream/docker-image?style=for-the-badge)

## Source

[GitHub](https://github.com/starudream/docker-image)

## License

[Apache License 2.0](https://github.com/starudream/docker-image/blob/master/LICENSE)
"

if [ -z "${DOCKER_USERNAME}" -o -z "${DOCKER_PASSWORD}" ]; then
  echo "Missing environment variables 'DOCKER_USERNAME' and 'DOCKER_PASSWORD'."
  exit 1
fi

_login_req=$(jq -nc --arg username "${DOCKER_USERNAME}" --arg password "${DOCKER_PASSWORD}" '{$username, $password}')
_login_resp=$(curl -sL -X POST -H "${DOCKER_REQUEST_HEADER}" -d "${_login_req}" "${DOCKER_API}/users/login")

TOKEN=$(echo "${_login_resp}" | jq -r 'select(.token != null) | .token')

if [ -z "${TOKEN}" ]; then
  echo "Unable to login docker hub, please check username and password ($(echo "${_login_resp}" | jq -r '.detail'))."
  exit 1
fi

_repository_req=$(jq -nc --arg registry "${DOCKER_REGISTRY}" --arg full_description "${DEFAULT_README}" '{$registry, $full_description}')
_repository_resp=$(curl -sL -X PATCH -H "${DOCKER_REQUEST_HEADER}" -H "Authorization: Bearer ${TOKEN}" -d "${_repository_req}" "${DOCKER_API}/repositories/${REPOSITORY}/")

NAME=$(echo "${_repository_resp}" | jq -r '.name')

echo "Repository '${NAME}' update finish."
