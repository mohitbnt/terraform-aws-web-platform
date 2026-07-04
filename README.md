# Terraform AWS Production Infrastructure (V2)

Production-oriented AWS infrastructure built with Terraform following Infrastructure as Code (IaC) best practices.

## Features

* Remote Terraform Backend (S3 + DynamoDB)
* Custom VPC with Public & Private Subnets
* Internet Gateway & NAT Instance
* Route Tables & Network Segmentation
* Security Groups (Least Privilege)
* IAM Roles & Instance Profiles
* Launch Template
* Auto Scaling Group
* Application Load Balancer (ALB)
* HTTPS with AWS Certificate Manager (ACM)
* Automatic ACM DNS Validation using Cloudflare
* Cloudflare DNS Management
* AWS Systems Manager (SSM)
* Interface VPC Endpoints
* Automated Nginx deployment using User Data

---

## Architecture

```text
Internet
    │
    ▼
Cloudflare DNS
    │
    ▼
Application Load Balancer (HTTPS)
    │
    ▼
Auto Scaling Group
    │
    ▼
Private EC2 Instances (Nginx)
    │
    ▼
Private Subnets
    │
    ▼
NAT Instance
    │
    ▼
Internet Gateway
```

Terraform Remote Backend

* Amazon S3
* DynamoDB State Locking

---

## Project Structure

```text
.
├── README.md
├── backend.tf
├── backend_bootstrap
│   ├── dynamodb.tf
│   └── s3.tf
├── certificate.tf
├── cloudflare.tf
├── compute.tf
├── data.tf
├── iam.tf
├── loadbalancer.tf
├── locals.tf
├── network.tf
├── providers.tf
├── security.tf
├── terraform.tfvars.example
├── userdata
│   ├── nat_instance_userdata.tftpl
│   └── nginx.tftpl
└── variables.tf
```

---

## Deployment

### 1. Bootstrap the Remote Backend

Deploy the resources inside `backend_bootstrap/` to create the S3 bucket and DynamoDB table.

### 2. Configure the Backend

Update `backend.tf` with the backend details and initialize Terraform.

```bash
terraform init
```

### 3. Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values according to your environment.

### 4. Deploy

```bash
terraform plan
terraform apply
```

---

## Current Version (V2)

### Implemented

* Remote State Backend
* Networking
* Security
* IAM
* Compute
* Auto Scaling
* Load Balancing
* AWS Systems Manager
* Interface Endpoints
* ACM Certificate
* Cloudflare DNS Validation
* Cloudflare Website DNS
* HTTP → HTTPS Redirect

---

## Upcoming (V3)

* CloudWatch Monitoring & Alarms
* AWS WAF
* Terraform Modules
* GitHub Actions CI/CD
* Terraform Workspaces
* CloudFront Integration

---

## Author

**Mohit Kumar**

Senior Linux & Cloud Engineer

