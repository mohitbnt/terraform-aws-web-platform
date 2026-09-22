# Terraform AWS Web Platform

A production-inspired Infrastructure as Code (IaC) project built with Terraform that provisions a highly available web application platform on AWS.

The project focuses on **modular Terraform design**, **production best practices**, **security**, and **maintainability**, rather than simply provisioning AWS resources.

---

## Features

- Modular Terraform architecture
- Remote state stored in Amazon S3
- Bootstrap project for backend creation
- Multi-AZ VPC
- Public and Private Subnets
- Internet Gateway
- Optional NAT Instance
- VPC Interface Endpoints (SSM)
- Security Groups using dedicated rule resources
- IAM Roles and Instance Profiles
- Auto Scaling Group
- Launch Templates
- Automatic SSH Key Pair generation
- Application Load Balancer
- HTTPS using ACM
- Cloudflare DNS integration
- Infrastructure tagging strategy
- TFLint support
- Infracost support

---

# Architecture

```
                    Internet
                        │
                        ▼
                Cloudflare DNS
                        │
                        ▼
           Application Load Balancer
                HTTP → HTTPS Redirect
                        │
                        ▼
                Auto Scaling Group
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
      EC2 Instance               EC2 Instance
          │                           │
          └─────────────┬─────────────┘
                        │
                Private Subnets
                        │
        VPC Interface Endpoints (SSM)
                        │
             Optional NAT Instance
                        │
               Internet Gateway
```

---

# Repository Structure

```
.
├── bootstrap/
├── modules/
│   ├── compute/
│   ├── domain/
│   ├── iam/
│   ├── loadbalancer/
│   ├── network/
│   └── security/
├── generated/
├── backend.tf
├── providers.tf
├── locals.tf
├── variables.tf
├── terraform.tfvars.example
└── README.md
```

---

# Modules

## Network

Responsible for:

- VPC
- Internet Gateway
- Public Subnets
- Private Subnets
- Route Tables
- Route Table Associations

---

## Security

Responsible for:

- Security Groups
- Ingress Rules
- Egress Rules

---

## IAM

Responsible for:

- IAM Roles
- IAM Instance Profiles
- Managed Policy Attachments

---

## Compute

Responsible for:

- Launch Template
- Auto Scaling Group
- NAT Instance (optional)
- EC2 SSH Key Generation
- User Data Templates

---

## Load Balancer

Responsible for:

- Application Load Balancer
- Target Group
- HTTP Listener
- HTTPS Listener

---

## Domain

Responsible for:

- ACM Certificate
- DNS Validation
- Cloudflare DNS Records
- Certificate Validation

---

# Prerequisites

- Terraform >= 1.5
- AWS CLI configured
- Cloudflare API Token
- AWS Account
- Cloudflare Hosted Domain

---

# Deployment

## 1. Bootstrap Remote State

```
cd bootstrap

terraform init
terraform apply
```

---

## 2. Configure Backend

Update `backend.tf` using the bucket created during bootstrap.

---

## 3. Configure Variables

Copy:

```
terraform.tfvars.example
```

to

```
terraform.tfvars
```

Populate the required values.

---

## 4. Initialize

```
terraform init
```

---

## 5. Review Plan

```
terraform plan
```

---

## 6. Deploy

```
terraform apply
```

---

# Generated SSH Keys

Terraform automatically generates SSH key pairs during deployment.

Generated private keys are stored under:

```
generated/
```

These files are intentionally excluded from version control.

---

# Project Highlights

This project demonstrates:

- Infrastructure modularization
- Module composition
- Reusable Terraform modules
- Dependency management
- Auto Scaling
- Secure private infrastructure
- Cloudflare integration
- ACM DNS validation
- Production-inspired tagging strategy
  
---

# Learning Objectives

This repository was created to practice production-style Terraform development rather than isolated Terraform syntax.

Topics covered include:

- Modules
- Variables
- Outputs
- Locals
- Data Sources
- Remote State
- IAM
- Networking
- Load Balancers
- Auto Scaling
- Cloudflare
- ACM
- Infrastructure Best Practices

---

# License

This project is provided for learning and demonstration purposes.
