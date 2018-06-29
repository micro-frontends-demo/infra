resource "aws_acm_certificate" "cert" {
  domain_name = "${local.site_domain}"
  subject_alternative_names = ["*.${local.site_domain}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.cert_validation_record_root.fqdn}",
    "${aws_route53_record.cert_validation_record_wildcard.fqdn}",
  ]
}

# For the root domain
resource "aws_route53_record" "cert_validation_record_root" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

# For all the child domains (wildcard)
resource "aws_route53_record" "cert_validation_record_wildcard" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_name}"
  type = "${aws_acm_certificate.cert.domain_validation_options.1.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.1.resource_record_value}"]
  ttl = 60
}
