terraform {
  backend "s3" {
    bucket = "terraform-state-46dc7020e6341676"
    key    = "handson-04"
    region = "us-east-1"
  }
}
