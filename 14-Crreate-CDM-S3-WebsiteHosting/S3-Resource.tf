resource "aws_s3_bucket" "Qumon_S3_bucket" {
  bucket = var.qa_Qumon_S3_bucket_Name


  tags = {
    name         = var.qa_Qumon_S3_bucket_Name
    environment  = var.s3_environment
    ownername    = "pradeeps@teknobuilt.com"
    businessunit = "Teknobuilt"
    created_by   = "Guddu Kumar Ray"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.Qumon_S3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "S3_website_hosting" {
  bucket = aws_s3_bucket.Qumon_S3_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.Qumon_S3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.Qumon_S3_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.Qumon_S3_bucket.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}