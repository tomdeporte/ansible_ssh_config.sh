#!/bin/bash

#az login \
#    --service-principal \
#    --username "${SERVICE_PRINCIPAL_ID}" \
#    --password "${SERVICE_PRINCIPAL_SECRET}" \
#    --tenant "${TENANT_ID}"

#az account set -s "${SUBSCRIPTION_ID}"

ssh-keygen -t rsa -N '' -f ~/.ssh/sshkey <<< y

RGs=$(az group list --query [].name -o tsv)
IFS=$'\n'
read -a strarr <<< "$RGs"
for rg in ${RGs[0]} ; do
  echo $rg
  if ! [ -z $(az vm list -g $rg --query "[].id" -o tsv) ] ; then
    VMs=$(az vm show -d --ids $(az vm list -g $rg --query "[].id" -o tsv) --query [name,privateIps])
    for vm in $VMs ; do
      name=$(echo ${vm[0]} | tr -d '"')
      host=$(echo ${vm[1]} | tr -d '"')
      key=$(echo $host | tr '_' '-')
      # Key vault name is dependant of environment 
      ssh-copy-id -i ~/.ssh/sshkey  -o "StrictHostKeyChecking no" gradesadmin@$host <<< $(az keyvault secret show --name $key --vault-name kv-common-fc-test-001 --query "value")
      ssh -i ~/.ssh/sshkey gradesadmin@$host
    done
  fi
done
