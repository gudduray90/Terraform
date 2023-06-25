## Here we will define AWS Account Details
# provider "aws" {
#   region = var.s3_bucket_region
#   access_key = var.accesskey
#   secret_key = var.secretkey
# }

provider "aws" {
  region     = var.s3_bucket_region
  access_key = var.accesskey
  secret_key = var.secretkey
}
