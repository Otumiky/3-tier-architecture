# Creating a 3-Tier Web Architecture Using Terraform

This guide outlines how to deploy a 3-tier architecture on AWS using Terraform. The architecture includes a web tier, application tier, and database tier, and demonstrates modular design principles for reusable components.

---

## Architecture Overview

## Architectural Diagram
![Alt text](https://github.com/Otumiky/3-tier-architecture/blob/main/project-root/3-tier%20Diagram%20natgatewayy.drawio.png)

### 1. **VPC Module**
The VPC module creates the network infrastructure:
- **Public Subnets** for the web tier (accessible from the internet).
- **Private Subnets** for the application and database tiers (isolated).
- Includes NAT Gateway for outbound internet access from private subnets.

### 2. **Web Tier**
- EC2 instances for hosting the web application.
- Elastic Load Balancer (ELB) for distributing traffic across multiple instances.

### 3. **Application Tier**
- Auto Scaling Groups (ASG) manage application servers.
- Scales instances based on load to ensure high availability.

### 4. **Database Tier**
- Amazon RDS for managing relational databases.
- Configured for high availability and disaster recovery with Multi-AZ.

---

## Deployment Steps

### Prerequisites
- **Terraform** installed on your system.
- **AWS CLI** configured with appropriate IAM permissions.
- A **key pair** created in AWS for EC2 access.

### Step 1: Clone the Repository
Download the Terraform configuration files:
```bash
git clone <repository-url>
cd <repository-folder>
```

### Step 2: Initialize Terraform
Initialize Terraform to download provider plugins and modules:
```bash
terraform init
```

### Step 3: Update Variables
Modify the `variables.tf` file to define the following:
- `vpc_cidr` (e.g., `10.0.0.0/16`)
- Subnet CIDRs (e.g., `10.0.1.0/24`, `10.0.2.0/24`)
- Availability Zones (e.g., `us-east-1a`, `us-east-1b`)
- `ami_id` and `instance_type` for EC2 instances.

### Step 4: Plan the Infrastructure
Preview the infrastructure changes Terraform will create:
```bash
terraform plan
```

### Step 5: Deploy the Infrastructure
Apply the Terraform configuration to create the architecture:
```bash
terraform apply
```
Review the proposed changes and confirm by typing `yes`.

---

## Additional Notes

1. **Security Groups**
   - Each tier has dedicated security groups to control traffic.
   - The web tier allows HTTP/HTTPS access from the internet.
   - The app tier and database tier allow restricted access from specific subnets.

2. **Modular Design**
   - The code uses modules for VPC, EC2, ELB, ASG, and RDS, ensuring reusability and scalability.

3. **Scalability**
   - ASG dynamically adjusts the number of EC2 instances based on traffic patterns.
   - RDS supports Multi-AZ for high availability and automatic failover.

4. **DNS Configuration**
   - AWS Route 53 can be integrated for custom domain names, but this was excluded in this project.

---

## Clean Up
To remove the resources and avoid charges:
```bash
terraform destroy
```
Confirm the destruction by typing `yes`.

---

## Future Enhancements
- Add AWS Route 53 for DNS and domain management.
- Implement monitoring and alerting using AWS CloudWatch.
- Extend the architecture with caching using Amazon ElastiCache.

---

Feel free to adapt the Terraform modules for your specific requirements!
