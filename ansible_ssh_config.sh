#!/bin/bash

#az login \
#    --service-principal \
#    --username "${SERVICE_PRINCIPAL_ID}" \
#    --password "${SERVICE_PRINCIPAL_SECRET}" \
#    --tenant "${TENANT_ID}"

#az account set -s "${SUBSCRIPTION_ID}"

ssh-keygen -t rsa -N '' -f ~/.ssh/sshkey <<< y

VMs=$(az vm list --show-details --output tsv --query "[?contains(storageProfile.osDisk.osType,'Linux')].id")
IFS=$'\n'
read -a strarr <<< "$VMs"
for id in $VMs ; do 
  name=$(az vm list --show-details --output tsv --query "[?id == '${id}'].name")
  key=$(echo $name | tr '_' '-')
  host=$(az vm list --show-details --output tsv --query "[?id == '${id}'].privateIps")
  echo name ; echo $key ; echo $host
  az keyvault secret show --name $key --vault-name kv-common-fc-test-001 --query "value"
  # Key vault name is dependant of environment 
  ssh-copy-id -i ~/.ssh/sshkey  -o "StrictHostKeyChecking no" gradesadmin@$host <<< $(az keyvault secret show --name $key --vault-name kv-common-fc-test-001 --query "value")
  ssh -i ~/.ssh/sshkey gradesadmin@$host
done
