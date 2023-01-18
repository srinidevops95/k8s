
####################
#     VPC
####################

resource "aws_vpc" "k8_vpc" {
  cidr_block       = var.VPC_CIDR
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "k8s-vpc"
  }
}

#################
### public subnet
#################
resource "aws_subnet" "k8_pub1" {
  vpc_id            = aws_vpc.k8_vpc.id
  cidr_block        = var.SUBNET_CIDR1
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "k8s-pub1"
  }
}

#####################
# Public subnet2
####################
### public subnet
resource "aws_subnet" "k8_pub2" {
  vpc_id            = aws_vpc.k8_vpc.id
  cidr_block        = var.SUBNET_CIDR2
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "k8s-pub2"
  }
}

/*
##################
### private subnet
##################
resource "aws_subnet" "k8_private1" {
  vpc_id            = aws_vpc.k8_vpc.id
  cidr_block        = var.SUBNET_CIDR3
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "k8s-pri1"
  }
}


##################
#  private subnet2
##################
### public subnet
resource "aws_subnet" "k8_private2" {
  vpc_id            = aws_vpc.k8_vpc.id
  cidr_block        = var.SUBNET_CIDR4
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "k8s-pri2"
  }
}
*/

#########
## IGW
########
resource "aws_internet_gateway" "k8_igw" {

 vpc_id   = aws_vpc.k8_vpc.id

tags = {
    Name = "k8s-igw"
  }
}



####################
# Public Route Table
###################
resource "aws_route_table" "k8rt_public" {


 vpc_id   = aws_vpc.k8_vpc.id


tags = {
    Name = "k8s-pub-rt"
  }
}

/*
#####################
# private route table
#####################
resource "aws_route_table" "k8rt_private" {


 vpc_id   = aws_vpc.k8_vpc.id


tags = {
    Name = "k8s-pri-rt"
  }
}

*/

######################
# route table association public
######################
resource "aws_route_table_association" "asso_public1" {


  subnet_id      = aws_subnet.k8_pub1.id
  route_table_id = aws_route_table.k8rt_public.id
}

###### Association public subnet2
resource "aws_route_table_association" "asso_public2" {


  subnet_id      = aws_subnet.k8_pub2.id
  route_table_id = aws_route_table.k8rt_public.id
}

###igw routing
resource "aws_route" "route1" {
      
  
  route_table_id         = aws_route_table.k8rt_public.id
  destination_cidr_block = var.CIDR_ALL
  gateway_id             = aws_internet_gateway.k8_igw.id
}




/*
################################
# route table association private1
################################
resource "aws_route_table_association" "asso_private1" {


  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rt_private .id
}


############ Association private subnet2
resource "aws_route_table_association" "asso_private2" {


  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rt_private .id
}





################
## NAT
################

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw_demo]
}


# Private NAT
resource "aws_nat_gateway" "nat_demo" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnet2.id
  depends_on        = [aws_internet_gateway.igw_demo]
tags = {
    Name = "k8s_nat"
  }
}




####### nat routing
 resource "aws_route" "nat_route" {
      
  
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = var.CIDR_ALL
  nat_gateway_id          = aws_nat_gateway.nat_demo.id
}

*/


######################## SG ###########################


resource "aws_security_group" "k8s-SG" {
  name        = var.SG_NAME
  description = "Allow k8s required inbound traffic"
  vpc_id      = aws_vpc.k8_vpc.id

  ingress {
    description      = "Allow of All Traffic-IPv4- 10252"
    from_port        = 10252
    to_port          = 10252
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "Allow of All Traffic ICMP - IPv4"
    from_port        = -1
    to_port          = -1
    protocol         = "ICMP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "Allow of All Traffic-IPv4- HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "Allow of All Traffic-IPv4- custom port range"
    from_port        = 2379
    to_port          = 2380
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "Allow of All Traffic-IPv4- 8001"
    from_port        = 8001
    to_port          = 8001
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "Allow of All Traffic-IPv4- HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }

ingress {
    description      = "Allow of All Traffic-IPv4- 10250"
    from_port        = 10250
    to_port          = 10250
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }

ingress {
    description      = "Allow of All Traffic-IPv4- My IP to ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress {
    description      = "Allow of All Traffic-IPv4-8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]

  }
ingress{
  description      = "Allow of All UDP - IPv4-10251"
  from_port         = 10251
  to_port           = 10251
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]

  }
ingress{
  description      = "Allow of All Traffic-IPv4- 30000-32767"
  from_port         = 30000
  to_port           = 32767
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]

  }
ingress{
  description      = "Allow of All Traffic-IPv4-6443"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]

  }
ingress {
    description = "Allow all traffic with in self SG"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
      Name	= "k8s-SG"
      Deployer	= "srinivas.a@mobileum.com"
 }
}



##################### EC2 #############################

resource "aws_instance" "k8_master" {
  ami                    = var.AMI
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = aws_subnet.k8_pub1.id
  iam_instance_profile   = var.INSTANCE_ROLE
  vpc_security_group_ids = [aws_security_group.k8s-SG.id]
  key_name               = var.KEY_NAME
  tags = {
          Name     = "k8s-master"
          Deployer = "srinivas.a@mobileum.com"
  }
}


resource "aws_eip" "master" {


  instance = aws_instance.k8_master.id
  vpc      = true

tags = {
        Name = "eip_master"
        Deployer = "srinivas.a@mobileum.com"
  }
}

resource "aws_eip_association" "ad_assoc_master" {


  instance_id   = aws_instance.k8_master.id
  allocation_id = aws_eip.master.id
}


resource "aws_instance" "k8_worker1" {
  ami                    = var.AMI
  instance_type          = var.WINSTANCE_TYPE
  subnet_id              = aws_subnet.k8_pub1.id
  iam_instance_profile   = var.INSTANCE_ROLE
  vpc_security_group_ids = [aws_security_group.k8s-SG.id]
  key_name               = var.KEY_NAME
  tags = {
          Name     = "k8s-worker1"
          Deployer = "srinivas.a@mobileum.com"
  }
}


resource "aws_eip" "worker1" {


  instance = aws_instance.k8_worker1.id
  vpc      = true

tags = {
        Name = "eip_worker1"
        Deployer = "srinivas.a@mobileum.com"
  }
}

resource "aws_eip_association" "ad_assoc_worker1" {


  instance_id   = aws_instance.k8_worker1.id
  allocation_id = aws_eip.worker1.id
}


resource "aws_instance" "k8_worker2" {
  ami                    = var.AMI
  instance_type          = var.WINSTANCE_TYPE
  subnet_id              = aws_subnet.k8_pub1.id
  iam_instance_profile   = var.INSTANCE_ROLE
  vpc_security_group_ids = [aws_security_group.k8s-SG.id]
  key_name               = var.KEY_NAME
  tags = {
          Name     = "k8s-worker2"
          Deployer = "srinivas.a@mobileum.com"
  }
}


resource "aws_eip" "worker2" {


  instance = aws_instance.k8_worker2.id
  vpc      = true

tags = {
        Name = "eip_worker2"
        Deployer = "srinivas.a@mobileum.com"
  }
}

resource "aws_eip_association" "ad_assoc_worker2" {


  instance_id   = aws_instance.k8_worker2.id
  allocation_id = aws_eip.worker2.id
}





