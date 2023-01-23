#!/bin/bash

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#az login \
#    --service-principal \
#    --username "${SERVICE_PRINCIPAL_ID}" \
#    --password "${SERVICE_PRINCIPAL_SECRET}" \
#    --tenant "${TENANT_ID}"

#az account set -s "${SUBSCRIPTION_ID}"

ssh-keygen -t rsa -N '' <<< y

VMs=$(az vm list --show-details --output tsv --query "[?contains(storageProfile.osDisk.osType,'Linux')].id")
IFS=$'\n'
read -a strarr <<< "$VMs"
for id in $VMs ; do 
  name=$(az vm list --show-details --output tsv --query "[?id == '${id}'].name")
  key=$(echo $name | sed "s/vm/key/g"  | tr '_' '-')
  host=$(az vm list --show-details --output tsv --query "[?id == '${id}'].privateIps")
  # Key vault name is dependant of environment 
  ssh-copy-id -o "StrictHostKeyChecking no" -p 9100 gradesadmin@$host <<< $(az keyvault secret show --name $key --vault-name kv-common-fc-test-001 --query "value")
  ssh -p 9100 gradesadmin@$host
done
