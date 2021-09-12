#terraform {
 # required_providers {
 #      aws = {
 #        source = "hashicorp/aws"
 #      }
 #      random ={
 #        source = "hashicorp/random"
 #      }
 # }
#}

#backend "remote" {
#  organizations = "Julie-Laursen"
#}

#workspaces {
 # name = "wedding_website"
#}

provider "aws" {
  source = "hashicorp/aws"
  region = var.aws_region
  #aws_access_key_id = var.aws_access_key_id
  #aws_secret_key = var.aws_secret_key
}


provider "cloudflare" {
  #Cloudflare email saved in $CLOUDFLARE_EMAIL
  # email = var.CLOUDFLARE_EMAIL
  #Cloudflare api token saved in $CLOUDFLARE_API_TOKEN
  
}

resource "aws_s3_bucket" "site" {
  bucket = var.site_domain
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.site_domain}"
  acl    = "private"
  policy = ""

  website {
    redirect_all_requests_to = "https://${var.site_domain}"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      },
    ]
  })
}

data "cloudflare_zones" "domain" {
  filter {
    name = var.site_domain
  }
}

resource "cloudflare_record" "site_cname" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.site_domain
  value   = aws_s3_bucket.site.website_endpoint
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www"
  value   = var.site_domain
  type    = "CNAME"

  ttl     = 1
  proxied = true
}