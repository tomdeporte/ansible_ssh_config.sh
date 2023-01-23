#!/bin/bash

FOLDER=/root/ansible
#if [ -d "$FOLDER" ]; then
#    echo "Ansible is already installed"
#else 
    sudo mkdir /root/ansible
    
    cd /home/gradesadmin

    sudo apt-get install ansible -y

    # Install Python 3 and pip.
    sudo apt-get install -y python3-pip

    # Upgrade pip3.
    pip3 install --upgrade pip

    # Install Ansible az collection for interacting with Azure.
    sudo ansible-galaxy collection install azure.azcollection

    # Install Ansible modules for Azure
    pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

    sudo echo -e "[defaults]\ninventory=/root/ansible/inventory\nremote_user=root\nhost_key_checking=False\nbecome=True\nbecome_user=root\nbecome_ask_pass=False\n" | sudo tee -a /root/ansible/ansible.cfg

    sudo echo -e "[apache]\n192.168.0.100\n[mariadb]\n192.168.0.101" | sudo tee -a /root/ansible/inventory

    export ANSIBLE_CONFIG=/root/ansible/ansible.cfg

    sudo echo "export ANSIBLE_CONFIG=/root/ansible/ansible.cfg" >> ~/.profile

    source ~/.profile
#fi


