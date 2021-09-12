variable "aws_region" {
  type        = string
  description = "The AWS region to put the bucket into"
  default     = "us-east-1"
}

variable "site_domain" {
  type        = string
  description = "The domain name to use for the static site"
  default = "julielawrence.net"
}

variable "cloudflare_api_token" {
  type        = string
  description = "The cloudflare Api key"
  default     = null
}