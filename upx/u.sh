#!/usr/bin/env bash

curl -s https://api.github.com/repos/starudream/upx/branches/devel | jq -r .commit.sha > latest-devel-sha
