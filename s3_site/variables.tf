variable "domain" {
  type = "string"
  description = "The FQDN where the site should be hosted"
}

variable "hosted_zone_id" {
  type = "string"
  description = "The ID of the Route53 hosted zone where DNS records should live"
}

variable "acm_certificate_arn" {
  type = "string"
  description = "The ARN of the ACM certificate that will front this site"
}

variable "uri_rewriter_arn" {
  type = "string"
  description = "The ARN of a lambda function that will rewrite URIs in some requests"
}
