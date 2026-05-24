terraform {
  backend "s3" {
    bucket         = "agri-prod-terraform-s3-state"                   # name of S3 bucket
    key            = "infra/terraform.tfstate"                        # path inside bucket
    region         = "ap-south-2"                                     # "ap-south-2"
    encrypt        = true                                             # encrypt state with SSE
  }
}