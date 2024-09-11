# CREATES WACL FOR WEB APPLICATION FIREWALL WITH THE POLICIES ATTACHED

resource "aws_wafv2_web_acl" "cloudgen_webserver_waf" {
  name = var.waf_wacl_name
  description = var.waf_description
  scope = var.waf_scope

  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_enabled
    metric_name = "WAFWEBACL-metric"
    sampled_requests_enabled = var.sampled_requests_enabled
  }
  
  dynamic "rule" {
    for_each = var.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_statement_name
          vendor_name = rule.value.managed_rule_group_statement_vendor_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = true
      }
    }
  }
}


# Associate the WebACL with the Internet-Facing Application Load Balancer

resource "aws_wafv2_web_acl_association" "web_acl_association" {
    resource_arn = var.alb_arn
    web_acl_arn = aws_wafv2_web_acl.cloudgen_webserver_waf.arn
}