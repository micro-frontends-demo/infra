# infra

Creates all the infrastructure to host a micro frontends demo.

## Stop! You probably don't need this

If you're just trying to play around with micro frontends on your own computer,
then you don't need to run this code.

This repo is a bunch of terraform code for provisioning the base infrastructure
required to host a micro-frontends-based website. So unless you're trying to
create your own web deployment of the demo, hosted in an AWS account that you
have API access to, you should not try to execute it.

## Getting started

1. Clone the repo
2. Install terraform
3. Configure your AWS account API credentials
4. Change the hard-coded stuff in `main.tf` to refer to a domain and S3 bucket that you own
3. Run terraform commands as normal. For example:
    1. `terraform init`
    2. `terraform plan`
    3. `terraform apply`
