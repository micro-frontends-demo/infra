locals {
  origin_id = "s3_origin"
}

resource "aws_cloudfront_distribution" "cloudfront_distro" {
  aliases = ["${var.domain}"]
  comment = "Cloudfront distribution for ${var.domain}"
  default_root_object = "index.html"
  enabled = true
  is_ipv6_enabled = true

  origin {
    domain_name = "${aws_s3_bucket.site_bucket.bucket_regional_domain_name}"
    origin_id = "${local.origin_id}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.cloudfront_access.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.origin_id}"
    viewer_protocol_policy = "redirect-to-https"
    compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
      headers = ["Origin"]
    }
  }

  # Needed for single-page apps with client-side routing
  custom_error_response {
    error_code = "404"
    response_code = "200"
    response_page_path = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn = "${var.acm_certificate_arn}"
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_access" {
  comment = "Cloudfront accessing S3 bucket for ${var.domain}"
}
