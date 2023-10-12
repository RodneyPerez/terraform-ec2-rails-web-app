data "aws_route53_zone" "selected" {
  name = var.hosted_zone
}

#resource "aws_route53_record" "clinic_sub" {
#  zone_id = data.aws_route53_zone.selected.zone_id
#  name    = var.env == "production" ? "*.${data.aws_route53_zone.selected.name}" : "*.${var.env}.${data.aws_route53_zone.selected.name}"
#  type    = "A"
#
#  alias {
#    name                   = aws_lb.alb.dns_name
#    zone_id                = aws_lb.alb.zone_id
#    evaluate_target_health = true
#  }
#}
resource "aws_route53_record" "standard" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.env}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
