terraform {
  backend "s3" {
    bucket         = "tfstate-ru-1012"
    key            = "backend/terraform-pactice-project.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "remote-backend"
  }
}
