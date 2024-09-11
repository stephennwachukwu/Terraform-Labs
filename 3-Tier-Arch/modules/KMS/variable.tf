variable "kms_user_name" {
  type = string
  default = "kms-encryption-storage"
}

variable "kms_policy_name" {
  type = string
  default = "kms_policy"
}

variable "enable_customer_managed_key" {
  description = "Enables dynamic creation of the KMS resources." # set to false to disable KMS resource creation !!!!

  type = bool
  default = true
}

variable "deletion_windows" {
  type = number
  default = 30
}

variable "key_rotation" {
  description = "(Optional) Specifies whether key rotation is enabled. Defaults to false."
  type = bool
  default = false 
}

variable "multi_region" {
  description = "(Optional) Indicates whether the KMS key is a multi-Region (true) or regional (false) key. Defaults to false."
  type = bool
  default = false
}

variable "is_enabled" {
  description = "(Optional) Specifies whether the key is enabled. Defaults to true."
  type = bool
  default = true
}

variable "customer_master_key_spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_256, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT"

  type = string
  default = "SYMMETRIC_DEFAULT"
}