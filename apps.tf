locals {
  apps = {
    root = "https://${local.site_domain}",
    content = "https://content.${local.site_domain}",
    browse = "https://browse.${local.site_domain}",
    order = "https://order.${local.site_domain}"
  }
}

module "container" {
  source = "./s3_site/"
  domain = "${replace(local.apps["root"], "https://", "")}"
  all_domains = "${values(local.apps)}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
  uri_rewriter_arn = "${aws_lambda_function.uri_rewriter.qualified_arn}"
}

module "static_content" {
  source = "./s3_site/"
  domain = "${replace(local.apps["content"], "https://", "")}"
  all_domains = "${values(local.apps)}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
  uri_rewriter_arn = "${aws_lambda_function.uri_rewriter.qualified_arn}"
}

module "restaurant_browse_app" {
  source = "./s3_site/"
  domain = "${replace(local.apps["browse"], "https://", "")}"
  all_domains = "${values(local.apps)}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
  uri_rewriter_arn = "${aws_lambda_function.uri_rewriter.qualified_arn}"
}

module "restaurant_order_app" {
  source = "./s3_site/"
  domain = "${replace(local.apps["order"], "https://", "")}"
  all_domains = "${values(local.apps)}"
  hosted_zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  acm_certificate_arn = "${aws_acm_certificate.cert.arn}"
  uri_rewriter_arn = "${aws_lambda_function.uri_rewriter.qualified_arn}"
}
