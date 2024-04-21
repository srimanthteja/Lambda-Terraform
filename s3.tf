resource "aws_s3_bucket" "terraform-state" {
  bucket = "vettel5terraformstate"
}

resource "aws_s3_bucket" "vettel_lambda_bucket" {
  bucket = "vettellambdabucket"
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.vettel_lambda_bucket.id
  key    = "lambda/delete_stale_vol.zip"
  source = "~/Terraform/lambda-terraform/delete_stale_volume.zip"
}

