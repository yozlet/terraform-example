#! /bin/bash
PLUGIN_PATH="${HOME}/workspace/terraform-provider-launchdarkly"
OUTPUT_DIR="${PWD}/terraform.d/plugins/linux_amd64"
docker run --rm \
    --volume ${PLUGIN_PATH}:/usr/src/plugin \
    --volume ${OUTPUT_DIR}:/usr/out \
    --env GOFLAGS="-mod=vendor" \
    --workdir /usr/src/plugin \
    golang:1.12 \
    go build -v -o /usr/out/terraform-provider-launchdarkly
