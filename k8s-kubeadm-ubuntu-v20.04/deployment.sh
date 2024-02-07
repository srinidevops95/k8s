#!/bin/bash

master_ip=$(cat ip.out | awk '{print $3}' | sed -n '1p')
echo "master IP is: ${master_ip}"

#get worker1 node IP
worker1_ip=$(cat ip.out | awk '{print $3}' | sed -n '2p')
echo "worker1 IP is: ${worker1_ip}"

#Get worker2 node IP
#worker2_ip=$(cat ip.out | awk '{print $3}' | sed -n '3p')
#echo "worker2 IP is: ${worker2_ip}"



ansible -m ping master --extra-vars "mip=${master_ip}" -i inventory/k8s.ini
ansible -m ping worker1 --extra-vars "w1_eip=${worker1_ip}" -i inventory/k8s.ini
#ansible -m ping worker2 --extra-vars "w2_eip=${worker2_ip}" -i inventory/k8s.ini

# Configure all pre requisites for k8s setup on all nodes
#ansible-playbook k8s_install.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini
ansible-playbook k8s_install.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip}" -i inventory/k8s.ini -vv 

# Create k8s user and set permissions
#ansible-playbook users.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini
ansible-playbook users.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip}" -i inventory/k8s.ini

#Make master node ready
#ansible-playbook master.yml --extra-vars "mip=${master_ip}" -i inventory/k8s.ini
ansible-playbook master.yml --extra-vars "mip=${master_ip}" -i inventory/k8s.ini

# join workers to master
#ansible-playbook join-workers.yml --extra-vars "w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini
ansible-playbook join-workers.yml --extra-vars "w1_eip=${worker1_ip}" -i inventory/k8s.ini

