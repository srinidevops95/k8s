#!/bin/bash

INITIAL_PASSWORD="k8s@123"
CA_PATH=/root/users
NAMESPACE=k8s-demo
ROLE_NAME=k8s-demo
ROLE_BINDING=k8s-demo-rolebinding


for i in $(cat $1); do
        # check the user existance
        getent passwd $i > /dev/null 2&>1

        # check the user existed or not. add user if not exists
        if [ $? -ne 0 ]; then
                echo "[INFO]: $i user does not exists in the server, hence going to add user $i"
                echo
                useradd $i
                echo "[SUCCESS]: user $i has been created successfully"
                echo
                echo "$i:$INITIAL_PASSWORD" | chpasswd
                chage -d 0 $i
                echo "Password for user $i changed successfully"

                ### ###########################
                cd /home/$i
                echo "connected to user home directory"

                ######## Create certificates #################3
                openssl genrsa -out $i.key 2048
                openssl req -new -key $i.key -out $i.csr -subj "/CN=$i/O=k8s-demo"
                echo "certificates .key, .csr files got created for user $i"

                ##### set certificate expiry for the cluster ###########
                openssl x509 -req -in $i.csr -CA ${CA_PATH}/ca.crt -CAkey ${CA_PATH}/ca.key -CAcreateserial -out $i.crt -days 365
                echo "made certificate validity for 1 year"

                ############# configure user config to access k8s cluster ############
                kubectl --kubeconfig $i.kubeconfig config set-cluster kubernetes --server https://10.16.1.205:6443 --certificate-authorit
y=${CA_PATH}/ca.crt

                kubectl --kubeconfig $i.kubeconfig config set-credentials $i --client-certificate ./$i.crt --client-key ./$i.key

                kubectl --kubeconfig $i.kubeconfig config set-context $i-kubernetes --cluster kubernetes --namespace ${NAMESPACE} --user
$i
                echo "set a user scope to specific namespace"

                ######### create a role binding ################
                ##kubectl create rolebinding ${ROLE_BINDING} --role=${ROLE_NAME} --user=$i --namespace=${NAMESPACE}
                ##echo "added role to user $i"
                mkdir .kube
                #touch .kube/config
                mv $i.kubeconfig .kube/config
                chown -R $i:$i /home/$i
                echo "[OK]: user $i added to k8s"

        else
                echo "[WARNING]: $i user has already exist"
                echo
                eval "$(echo "rm 1")"
        fi
done
