terraform {
  backend "s3" {
    bucket         = "webserver-state"
    key            = "webserver/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-lock"
    encrypt        = true
  }
}