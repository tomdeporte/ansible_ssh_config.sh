#!/bin/bash

ssh-keygen -b 2048 -t rsa -f /sshkey -q -N ""

export RGs=$(az group list --query [].name -o tsv)
for rg in ${RGs[0]} ; do
  echo $rg
  sleep 5
  az vm show -d --ids $(az vm list -g $rg --query "[].id" -o tsv) --query privateIps
done

az vm show -d --ids $(az vm list -g $RG --query "[].id" -o tsv) --query privateIps

ssh-copy-id -i ~/.ssh/sshkey user@host

ssh -i ~/.ssh/sshkey user@host
