# Bootstrap

This directory contains a separate Terraform project responsible for creating the remote backend infrastructure used by the main project.

Keeping the bootstrap configuration separate avoids the circular dependency of Terraform attempting to create the backend it is simultaneously trying to use.

---

# Resources Created

- S3 Bucket
- Bucket Versioning
- Bucket Encryption
- Public Access Block

---

# Deployment

```
terraform init

terraform apply
```

After deployment, update the main project's `backend.tf` with the bucket name.

---

# Why Separate Bootstrap?

Terraform cannot create an S3 backend and use it in the same execution.

The bootstrap project solves this problem by provisioning the backend infrastructure first.

---

# Notes

This project is intended to be executed only once per AWS account unless a new backend is required.
