#!/bin/bash

CA_PATH=/root/users


for i in $(cat $1); do
        # check the user existance
        getent passwd $i > /dev/null 2&>1

        # check the user existed or not. add user if not exists
        if [ $? -ne 0 ]; then
                echo "[WARNING]: $i user does not exists in the server, hence going to add user $i"
                #exit 0
                echo
        else
                echo "[OK]: $i user is exist and going to delete it now"
                userdel $i
                rm -rf /home/$i

        fi
done
