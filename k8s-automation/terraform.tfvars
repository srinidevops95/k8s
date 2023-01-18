############### Define VPC variable values ##################
VPC_CIDR	= "10.16.0.0/21"
SUBNET_CIDR1	= "10.16.1.0/24"
SUBNET_CIDR2	= "10.16.2.0/24"
SUBNET_AZ1	= "eu-west-1a"
SUBNET_AZ2	= "eu-west-1b"
CIDR_ALL	= "0.0.0.0/0"

############### Define EC2 variable values ##################
AMI		= "ami-05e786af422f8082a"
INSTANCE_TYPE	= "t3a.small"
WINSTANCE_TYPE   = "t2.micro"
INSTANCE_ROLE	= "gitlab-ec2-instance-role"
KEY_NAME	= "utility"
SG_NAME		= "k8s-SG"
AWS_REGION	= "eu-west-1"
