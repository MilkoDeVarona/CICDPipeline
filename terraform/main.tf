terraform {
 required_providers {
     aws = {
         source = "hashicorp/aws"
         version = "~>3.0"
     }
 }
}

# Configure the AWS provider
provider "aws" {
    region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "MyLab-VPC"{
    cidr_block = var.cidr_block[0]

    tags = {
        Name = "MyLab-VPC"
    }

}

# Create public subnet
resource "aws_subnet" "MyLab-Subnet1" {
  vpc_id = aws_vpc.MyLab-VPC.id
  cidr_block = var.cidr_block[1]

  tags = {
    Name = "MyLab-Subnet1"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "MyLab-IntGW" {
    vpc_id = aws_vpc.MyLab-VPC.id

    tags = {
      Name = "MyLab-InternetGW"
    }
}

# Create security group
resource "aws_security_group" "MyLab-SecGroup" {
  name = "MyLab Security Group"
  description = "Allows inbound and outbound traffic to EC2 instance"
  vpc_id = aws_vpc.MyLab-VPC.id

  dynamic ingress {
    iterator = port
    for_each = var.ports
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow traffic"
  }
}

# Create route table and associations
resource "aws_route_table" "MyLab-RouteTable" {
  vpc_id = aws_vpc.MyLab-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyLab-IntGW.id
  }

  tags = {
    Name = "MyLab-RouteTable"
  }
}

resource "aws_route_table_association" "MyLab-RTAssoc" {
  subnet_id = aws_subnet.MyLab-Subnet1.id
  route_table_id = aws_route_table.MyLab-RouteTable.id
}

# Create an EC2 instance to host Jenkins
resource "aws_instance" "Jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallJenkins.sh")

  tags = {
    Name = "MyLab-Jenkins-Server"
  }
}

# Create an EC2 instance to host Ansible
resource "aws_instance" "Ansible" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallAnsibleCN.sh")

  tags = {
    Name = "MyLab-Ansible-Server"
  }
}

# Create an EC2 instance (Ansible managed node 1) to host Apache Tomcat server
resource "aws_instance" "Ansible-ManagedNode1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallAnsibleMN1.sh")

  tags = {
    Name = "MyLab-MN1-TomCat-Server"
  }
}

# Create an EC2 instance (Ansible managed node 2) to host Docker
resource "aws_instance" "Ansible-ManagedNode2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallDocker.sh")

  tags = {
    Name = "MyLab-MN2-Docker-Server"
  }
}

# Create an EC2 instance to host Sonatype Nexus
resource "aws_instance" "Nexus" {
  ami           = var.ami
  instance_type = var.instance_type_for_nexus
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallNexus.sh")

  tags = {
    Name = "MyLab-Nexus-Server"
  }
}

# Create an EC2 instance to host Sonatype SonarQube
resource "aws_instance" "SonarQube" {
  ami           = var.ami
  instance_type = var.instance_type_for_nexus
  key_name = var.key_pair
  vpc_security_group_ids = [aws_security_group.MyLab-SecGroup.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallSonarqube.sh")

  tags = {
    Name = "MyLab-SonarQube-Server"
  }
}
