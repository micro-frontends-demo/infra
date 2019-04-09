terraform {
  backend "s3" {
    bucket = "micro-frontends-demo-tfstate"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version = "~> 1.23.0"
  region = "us-east-1"
}

locals {
  site_domain = "demo.microfrontends.com"
}

data "aws_route53_zone" "hosted_zone" {
  name = "microfrontends.com"
}
