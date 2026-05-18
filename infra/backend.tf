terraform {
  backend "s3" {
    bucket         = "doyomo-terraform-s3-state"   # name of S3 bucket
    key            = "infra/terraform.tfstate"  # path inside bucket
    region         = "af-south-1"
    encrypt        = true                       # encrypt state with SSE
  }
}