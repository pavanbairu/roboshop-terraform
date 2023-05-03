# terraform state
terraform {
  backend "s3" {
    bucket = "pavanbairu"
    key = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}