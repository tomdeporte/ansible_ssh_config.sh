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
    IPs=$(az vm show -d --ids $(az vm list -g $rg --query "[].id" -o tsv) --query privateIps)
    for ip in $IPs ; do
      host=$(echo $ip | tr -d '"')
      echo $host
      ssh-copy-id -i ~/.ssh/sshkey user@$host
      ssh -i ~/.ssh/sshkey user@$host
    done
  fi
done

