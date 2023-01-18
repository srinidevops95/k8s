#!/bin/bash

#validate code
terraform validate

# plan code
terraform plan

# apply code
terraform apply

# take output into a file
terraform output > ip.out


# get the master node IP
master_ip=$(cat ip.out | awk '{print $3}' | sed -n '1p')
echo "master IP is: ${master_ip}"

#get worker1 node IP
worker1_ip=$(cat ip.out | awk '{print $3}' | sed -n '2p')
echo "worker1 IP is: ${worker1_ip}"

#Get worker2 node IP
worker2_ip=$(cat ip.out | awk '{print $3}' | sed -n '3p')
echo "worker2 IP is: ${worker2_ip}"



MASTER_EIP=`aws ec2 describe-addresses --region eu-west-1 --public-ips ${master_ip} --output text --query 'Addresses[*].AllocationId' | wc -l`

WORKER1_EIP=`aws ec2 describe-addresses --region eu-west-1 --public-ips ${worker1_ip} --output text --query 'Addresses[*].AllocationId' | wc -l`

WORKER2_EIP=`aws ec2 describe-addresses --region eu-west-1 --public-ips ${worker2_ip} --output text --query 'Addresses[*].AllocationId' | wc -l`

echo "[OK]: wait for a minute"

wait 60;

ansible -m ping master --extra-vars "mip=${master_ip}" -i inventory/k8s.ini
ansible -m ping worker1 --extra-vars "w1_eip=${worker1_ip}" -i inventory/k8s.ini
ansible -m ping worker2 --extra-vars "w2_eip=${worker2_ip}" -i inventory/k8s.ini


# check EIP existance 
if [ ${MASTER_EIP} == 1 ] && [ ${WORKER1_EIP} == 1 ] && [ ${WORKER2_EIP} == 1 ]; then
	echo -e "[OK]: $master_ip $worker1_ip $worker2_ip exists"
        # # deploy kubernates cluster
        # Configure all pre requisites for k8s setup on all nodes
        ansible-playbook k8s_install.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini

        # Create k8s user and set permissions
        ansible-playbook users.yml --extra-vars "mip=${master_ip} w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini

        #Make master node ready
        ansible-playbook master.yml --extra-vars "mip=${master_ip}" -i inventory/k8s.ini

        # join workers to master
        ansible-playbook join-workers.yml --extra-vars "w1_eip=${worker1_ip} w2_eip=${worker2_ip}" -i inventory/k8s.ini
else
	echo "[ERROR]: one of node IP not exists"
	
fi

