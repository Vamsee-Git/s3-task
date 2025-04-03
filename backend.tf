terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-two-tier-vamsee"
    key            = "terraform/s3-task"
    region         = "ap-south-1"
  }
}
