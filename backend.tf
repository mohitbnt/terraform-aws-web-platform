terraform {
  backend "s3" {
    bucket       = "terraform-backend-533317135122"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}