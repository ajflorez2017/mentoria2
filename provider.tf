#
#
#

provider "aws" {
  region = "us-east-1"
}

# #
# # Remote terraform state 
# #

# resource "aws_s3_bucket" "mentoria2" {
#   bucket = "mentoria2"

#   # Prevent accidental deletion

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.mentoria2.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

#   # Enable server-side encryption by default

# resource "aws_s3_bucket_server_side_encryption_configuration" "mentoria2" {
#   bucket = aws_s3_bucket.mentoria2.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "AES256"
#     }
#   }
  
# }


# # DynamoDb for locking

# resource "aws_dynamodb_table" "terraform_locks" {
#   name = "mentoria2"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket = "mentoria2"
#     key = "global/s3/terraform.state"
#     region = "us-east-1"
#     dynamodb_table = "mentoria2"
#   }
# }