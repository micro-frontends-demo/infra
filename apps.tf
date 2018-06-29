module "wrapper" {
  source = "./s3_site/"
  domain = "${local.site_domain}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
}

module "static_content" {
  source = "./s3_site/"
  domain = "content.${local.site_domain}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
}

module "restaurant_browse_app" {
  source = "./s3_site/"
  domain = "browse.${local.site_domain}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
}

module "restaurant_order_app" {
  source = "./s3_site/"
  domain = "order.${local.site_domain}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
}
