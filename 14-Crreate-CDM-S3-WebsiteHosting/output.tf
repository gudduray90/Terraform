output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}


output "S3-Static-website-domain" {
  value = aws_s3_bucket_website_configuration.S3_website_hosting.website_domain 	
}
