# THE VALUES FOR THE LIST OF EMPTY VARIABLES ARE GENERATED IN THE ROOT DIRECTORY CLOUDGEN/main.tf !!!
# WARNING!!!! DO NOT TOUCH OR EDIT

variable "alb_arn" {}

# END OF LIST OF EMPTY VARIABLES

##########################################################
          # WAF VARIABLES
##########################################################

variable "waf_wacl_name" {
  description = "(Required) Friendly name of the WebACL"
  type = string
  default = "cloudgen_webserver_waf"
}

variable "cloudgen_webserver_waf_name" {
  description = "(Required) Friendly name of the WAF"

  type = string
  default = "cloudgen_webserver_waf"
}

variable "waf_description" {
  description = "(Optional) Friendly description of the WebACL"

  type = string
  default = "waf for cloudgen web application"
}

variable "waf_scope" {
  description = "(Required) Specifies whether this is for an AWS CloudFront distribution or for a regional application"

  type = string
  default = "REGIONAL"
}

variable "cloudwatch_enabled" {
  description = "Dynamically enables cloudwatch "
  type = bool
  default = true
}

variable "sampled_requests_enabled" {
  description = "Enables sample requests"

  type = bool
  default = true
}

# SET OF AWS MANAGED WEB APPLICATION FIREWALL RULES

variable "rules" {
  type = list(any)
  default = [
    {
      name                                     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority                                 = 1
      managed_rule_group_statement_name        = "AWSManagedRulesAdminProtectionRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "admin_ruleset"
    },
    {
      name                                     = "AWS-AWSManagedRulesPHPRuleSet"
      priority                                 = 2
      managed_rule_group_statement_name        = "AWSManagedRulesPHPRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "php_ruleset"
    },
    {
      name                                     = "AWS-AWSManagedRulesLinuxRuleSet"
      priority                                 = 3
      managed_rule_group_statement_name        = "AWSManagedRulesLinuxRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "linux_ruleset"
    },
    {
      name                                     = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority                                 = 4
      managed_rule_group_statement_name        = "AWSManagedRulesAmazonIpReputationList"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "ip_reputationlist"
    },
    {
      name                                     = "AWS-AWSManagedRulesSQLiRuleSet"
      priority                                 = 5
      managed_rule_group_statement_name        = "AWSManagedRulesSQLiRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "sqlinjection_ruleset"
    },
    {
      name                                     = "AWS-AWSManagedRulesUnixRuleSet"
      priority                                 = 6
      managed_rule_group_statement_name        = "AWSManagedRulesUnixRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "unix_ruleset"
    },
    {
      name                                     = "AWS-AWSManagedRulesCommonRuleSet"
      priority                                 = 7
      managed_rule_group_statement_name        = "AWSManagedRulesCommonRuleSet"
      managed_rule_group_statement_vendor_name = "AWS"
      metric_name                              = "common_ruleset"
    }
  ]
}