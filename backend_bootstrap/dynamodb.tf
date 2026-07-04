#DynamoDB Table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  lifecycle {
    prevent_destroy = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "Terraform State Locking"
    Environment = "Global"
  }
}