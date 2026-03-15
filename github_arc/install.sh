#!/bin/bash
set -euo pipefail

THIS_DIR="$(dirname "$0")" || exit 1
source "${THIS_DIR}/credentials"

set -x


# https://docs.github.com/en/actions/tutorials/use-actions-runner-controller/quickstart
helm install arc \
    --namespace "arc-systems" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller


# https://github.com/actions/actions-runner-controller/blob/master/charts/gha-runner-scale-set/values.yaml
helm install arc-runner-set \
    --namespace "arc-runners" \
    --create-namespace \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_TOKEN}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
