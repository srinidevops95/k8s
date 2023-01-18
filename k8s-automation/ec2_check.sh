#!/bin/bash


REGION="eu-west-1"

function usage() {
  echo "$0 (start|stop|status)"
}

# Check input variable
if [ $# -ne 1 ]; then
  usage
  exit 2
fi

for i in i-00d8eb035c475820c i-009ef084033aa41fe i-0bab34edd38dda8fa
do 
INSTANCE_STATE=$(aws ec2 describe-instances --region eu-west-1 --instance-ids $i --output text --query 'Reservations[*].Instances[*].State.Name');
	if [ "$1" = "start" ]; then
  		if [ "$INSTANCE_STATE" = "running" ]; then
    			echo "$i instance is already running."
  		else
    			echo "start instance..."
    			$DEBUG aws ec2 start-instances --instance-ids $i --region $REGION
  		fi

	elif [ "$1" = "stop" ]; then
  		if [ "$INSTANCE_STATE" = "running" ]; then
    			echo "stop instance..."
    			$DEBUG aws ec2 stop-instances --instance-ids $i --region $REGION
  		else
    			echo " $i instance is already stopped."
  	fi

	elif [ "$1" = "status" ]; then
  		echo "$i is in ${INSTANCE_STATE} state"
	else
  		usage
fi

done;
