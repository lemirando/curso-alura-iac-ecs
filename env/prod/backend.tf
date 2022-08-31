terraform {
  backend "s3" {
    bucket = "bkt-tfstate-lmm"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}