variable "VPC_CIDR" {
        description     =  "Define VPC CIDR range"
        type            =   string
        default         = ""
}



variable "SUBNET_CIDR1" {
        description     =  "Define subnet1 CIDR"
        type            =   string
        default         = ""
}

variable "SUBNET_CIDR2" {
        description     =  "Define subnet2 CIDR"
        type            =   string
        default         = ""
}



variable "SUBNET_AZ1" {
        description     =  "Declare subnet AZ1"
        type            =   string
        default         = ""
}


variable "SUBNET_AZ2" {
        description     =  "Decalre subnet AZ2"
        type            =   string
        default         = ""
}


variable "CIDR_ALL" {
	description     = "Declare all CIDR"
	type		= string
	default		= ""
}


########################## EC2 ###################################

variable "AMI" {
	description	= "Declare AMI ID"
	type		= string
	default		= ""
}


variable "INSTANCE_TYPE" {
        description     = "Declare Instance type"
        type            = string
        default         = ""
}


variable "WINSTANCE_TYPE" {
        description     = "Declare Instance type"
        type            = string
        default         = ""
}


variable "INSTANCE_ROLE" {
        description     = "Declare Instance profile"
        type            = string
        default         = ""
}


variable "KEY_NAME" {
        description     = "Declare Key pair"
        type            = string
        default         = ""
}


variable "SG_NAME" {
	description	= "Declare SG Name"
	type		= string
	default		= ""
}



variable "AWS_REGION" {
        description     = "Declare AWS Region"
        type            = string
        default         = ""
}

