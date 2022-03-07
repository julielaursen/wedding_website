## Learn Terraform Cloudflare Static Website

Learn how to use Terraform to set up a static website using AWS bucket for object storage and Cloudflare for DNS, SSL and CDN. Follow along with [this tutorial](https://learn.hashicorp.com/tutorials/terraform/cloudflare-static-website) on HashiCorp Learn.

The [`acm-cloudfront`](https://github.com/hashicorp/learn-terraform-cloudflare-static-website/tree/acm-cloudfront) branch uses ACM for SSL certificate and Cloudfront for CDN. This configuration is more complex and works even if your S3 bucket name is already taken.

### Running Terraform ###

terraform apply
terraform run

### Uploading static files to S3 ###

aws s3 cp website/ s3://$(terraform output -raw website_bucket_name)/ --recursive

[![CodeScene System Mastery](https://codescene.io/projects/24272/status-badges/system-mastery)](https://codescene.io/projects/24272)
