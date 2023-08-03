terraform {
  backend "s3" {
    bucket         = "mentoria2"
    dynamodb_table = "terraform_locks"
    key            = "mentoria2"
    region         = "us-east-1"
        
    #  Authentication
    # profile        = "ajfb.aws"
  }
}