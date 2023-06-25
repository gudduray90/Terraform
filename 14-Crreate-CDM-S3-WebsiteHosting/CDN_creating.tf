resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.Qumon_S3_bucket.bucket_regional_domain_name
    #domain_name = "devtest-itag.pace-os.com.s3-website.ap-south-1.amazonaws.com"
    origin_id = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E9NEKC3XZND5E"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.qa_Qumon_S3_bucket_Name}"
  default_root_object = "index.html"

  aliases = ["${var.qa_Qumon_S3_bucket_Name}"]
  
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    #min_ttl                = 0
    #default_ttl            = 3600
    #max_ttl                = 86400
  }
  
  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations = []
    }
  }
  
  viewer_certificate {
    acm_certificate_arn      = "${var.pace-os-acm-certificate}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}
