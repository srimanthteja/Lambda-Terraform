terraform {
  backend "s3" {
    bucket = "vettel5terraformstate"
    region = "us-east-1"
    key    = "vettel/terraform.tfstate"
    #dynamodb_table = "terraform_lock"
  }
}
