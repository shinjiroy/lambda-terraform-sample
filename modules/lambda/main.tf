data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Lambda用ロール
# ※サンプルでは全Lambdaで同じロールを使い回すけど、実際使う時はちゃんとLambda別に作った方が良い
resource "aws_iam_role" "this" {
  name               = "Lambda-Sample-${title(var.short_environment)}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  path               = "/service-role/"
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "/apps/dist_lambda/bukkonuki"
  output_path = "/apps/dist_lambda/bukkonuki.zip"
}

resource "aws_lambda_function" "sample" {
  architectures                  = ["x86_64"]
  description                    = "Lambdaサンプル"
  filename                       = data.archive_file.this.output_path
  function_name                  = "LambdaSample${title(var.short_environment)}"
  handler                        = "app.lambda_handler"
  package_type                   = "Zip"
  publish                        = true
  role                           = aws_iam_role.this.arn
  runtime                        = "python3.12"
  skip_destroy                   = false
  source_code_hash               = data.archive_file.this.output_base64sha256
  logging_config {
    application_log_level = null
    log_format            = "Text"
    log_group             = "/aws/lambda/LambdaSample${title(var.short_environment)}"
    system_log_level      = null
  }
  tracing_config {
    mode = "PassThrough"
  }
}
