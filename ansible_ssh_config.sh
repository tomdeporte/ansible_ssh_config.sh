#!/bin/bash

ssh-keygen -b 2048 -t rsa -f /sshkey -q -N ""

RGs=$(az group list --query [].name -o tsv)
IFS=$'\n'
read -a strarr <<< "$RGs"
for rg in ${RGs[0]} ; do
  echo $rg
  if ! [ -z $(az vm list -g $rg --query "[].id" -o tsv) ] ; then
    IPs=$(az vm show -d --ids $(az vm list -g $rg --query "[].id" -o tsv) --query privateIps)
    for ip in $IPs ; do
      host=$(echo $ip | tr -d '"')
      ssh-copy-id -i ~/.ssh/sshkey user@$host
      ssh -i ~/.ssh/sshkey user@$host
    done
  fi
done

