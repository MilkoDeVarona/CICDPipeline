# Complete CI/CD Pipeline

## Step 1
### Create infrastructure (IaC)
Provision complete virtual data center on AWS using Terraform as the Infrastructure as Code (IaC) tool. 
Create the following resources:
- VPC
- Subnets
- Internet Gateway
- Security Groups
- Route Table
- EC2 instances

## Step 2
### Configure Continuous Integration (CI)
- Setup Git as the version control tool
- Setup GitHub as source code repository
- Setup Jenkins as continuous integration tool
- Setup Maven as build tool
- Setup Nexus as maven repository manager to publish artifacts

## Step 3
### Configure Continous Delivery/Deployment (CD)
- Setup Ansible as deployment tool
- Setup Apache TomCat for webserver
- Setup Docker to containerize application
- Setup SonarQube for continuous code quality inspection