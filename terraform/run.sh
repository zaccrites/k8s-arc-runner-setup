#!/bin/bash
cd "$(dirname "$0")" || exit 1

source credentials
doToken="${DIGITAL_OCEAN_TOKEN}"
pvtKey="${HOME}/.ssh/id_rsa"

if [[ "$1" == init ]]; then
  terraform init
elif [[ "$1" == plan ]]; then
  terraform plan -var "do_token=${doToken}" -var "pvt_key=${pvtKey}"
elif [[ "$1" == apply ]]; then
  terraform apply -auto-approve -var "do_token=${doToken}" -var "pvt_key=${pvtKey}"
elif [[ "$1" == show ]]; then
  terraform show terraform.tfstate
elif [[ "$1" == destroy ]]; then
  planName="$(mktemp)"
  terraform plan \
    -destroy -out="${planName}" \
    -var "do_token=${doToken}" -var "pvt_key=${pvtKey}"
  terraform apply "${planName}"
  rm "${planName}"
else
  echo "unknown command"
  exit 1
fi

