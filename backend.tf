terraform {
  backend "s3" {
    bucket         = "cloudsolutions-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}