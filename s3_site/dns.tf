resource "aws_route53_record" "app_subdomain_record" {
  zone_id = "${var.hosted_zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cloudfront_distro.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cloudfront_distro.hosted_zone_id}"
    evaluate_target_health = false
  }
}
