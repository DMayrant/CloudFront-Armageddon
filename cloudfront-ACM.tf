resource "aws_cloudfront_distribution" "app" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront in front of ALB (${var.env})"

  aliases = ["chewbacca-growl.com"]

  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Cloudfront-${var.env}"
  }

  depends_on = [
    aws_acm_certificate_validation.cloudfront
  ]
}


resource "aws_acm_certificate" "cloudfront" {
  provider          = aws.use1
  domain_name       = "chewbacca-growl.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider        = aws.use1
  certificate_arn = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation : record.fqdn
  ]
}

