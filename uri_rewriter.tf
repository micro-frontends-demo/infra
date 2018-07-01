locals {
  src_file = "uri_rewriter.js"
  zip_file = "uri_rewriter.zip"
}

resource "null_resource" "package_lambda_zip" {
  triggers = {
    file_contents = "${base64sha256(file(local.src_file))}"
  }

  provisioner "local-exec" {
    command = "zip ${local.zip_file} ${local.src_file}"
  }
}

resource "aws_lambda_function" "uri_rewriter" {
  depends_on = ["null_resource.package_lambda_zip"]

  description = "Rewrites URIs for '/static/js/main.abcd1234.js' to '/static/js/bundle.js'"
  filename = "${local.zip_file}"
  function_name = "uri_rewriter"
  role = "${aws_iam_role.uri_rewriter_role.arn}"
  handler = "uri_rewriter.handler"
  source_code_hash = "${base64sha256(file(local.zip_file))}"
  runtime = "nodejs8.10"
  publish = true
}

resource "aws_iam_role" "uri_rewriter_role" {
  name = "uri_rewriter_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "uri_rewriter_role_policy" {
  name = "uri_rewriter_role_policy"
  role = "${aws_iam_role.uri_rewriter_role.id}"
  policy = "${data.aws_iam_policy_document.uri_rewriter_permissions.json}"
}

data "aws_iam_policy_document" "uri_rewriter_permissions" {
  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = ["lambda:GetFunction", "lambda:EnableReplication*"]
    resources = ["${aws_lambda_function.uri_rewriter.qualified_arn}"]
  }

  statement {
    actions = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
  }

  statement {
    actions = ["cloudfront:UpdateDistribution"]
    resources = [
      "${module.wrapper.distribution_arn}",
      "${module.static_content.distribution_arn}",
      "${module.restaurant_browse_app.distribution_arn}",
      "${module.restaurant_order_app.distribution_arn}"
    ]
  }
}
