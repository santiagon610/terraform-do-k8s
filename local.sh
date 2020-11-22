#!/bin/bash
set -ex
source ./secret.sh
terraform init
terraform validate -json | jq
terraform plan -out /tmp/local.tfplan
terraform apply /tmp/local.tfplan