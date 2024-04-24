# ------------------------------------------------------------------------------
# CREATE EITHER S3 OBJECT OR ARCHIVE FILE
# ------------------------------------------------------------------------------

# Here lambda function will be created from zip file uploaded in s3 bucket where key is path for zip file in the bucket.
data "aws_s3_object" "lambda" {
  count  = var.s3_bucket != "" && var.s3_key != "" ? 1 : 0
  bucket = var.s3_bucket
  key    = var.s3_key
}

# Here a zip file will be created when source_file is passed and lambda function will be created from that zip file
data "archive_file" "lambda" {
  count       = var.source_file != "" && var.output_path != "" ? 1 : 0
  type        = "zip"
  source_file = var.source_file
  output_path = var.output_path
}

data "aws_ssm_parameter" "env_vars_from_parameter_store" {
  for_each = var.env_vars_from_parameter_store
  name     = each.value
}

locals {
  env_vars_from_parameter_store = length(keys(var.env_vars_from_parameter_store)) == 0 ? {} : zipmap(
    [for key, value in var.env_vars_from_parameter_store : key],
    [for parameter in data.aws_ssm_parameter.env_vars_from_parameter_store : parameter.value]
  )
  environment_variables = length(keys(var.environment_variables)) == 0 && length(keys(local.env_vars_from_parameter_store)) == 0 ? [] : [merge(var.environment_variables, local.env_vars_from_parameter_store)]
}

# ------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION
# ------------------------------------------------------------------------------
#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "lambda" {
  function_name     = var.function_name
  description       = var.description
  handler           = var.handler
  memory_size       = var.lambda_memory
  role              = aws_iam_role.lambda.arn
  runtime           = var.lambda_runtime
  timeout           = var.lambda_timeout
  s3_bucket         = try(data.aws_s3_object.lambda[0].bucket, null)
  s3_key            = try(data.aws_s3_object.lambda[0].key, null)
  s3_object_version = try(data.aws_s3_object.lambda[0].version_id, null)
  source_code_hash  = try(data.aws_s3_object.lambda[0].metadata.source_code_hash, null)
  filename          = try(data.archive_file.lambda[0].output_path, null)
  layers            = var.layers_arn
  publish           = var.publish

  dynamic "environment" {
    for_each = length(local.environment_variables) == 0 ? [] : local.environment_variables
    content {
      variables = environment.value
    }
  }

  dynamic "vpc_config" {
    for_each = var.subnets != null && var.security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnets
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------------------
# ASSIGN PERMISSION TO API GATEWAY, COGNITO, SQS, SNS, Cloudwatch Scheduler AND EVENTBRIDGE
# ------------------------------------------------------------------------------------------

resource "aws_lambda_permission" "api" {
  count         = var.enable_api_invoke_permission ? 1 : 0
  statement_id  = "AllowAPIGWLambdaInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigw_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "cognito" {
  count         = var.enable_cognito_invoke_permission ? 1 : 0
  statement_id  = "AllowCognitoPoolLambdaInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.cognito_pool_arn
}

resource "aws_lambda_permission" "sqs" {
  count         = var.enable_sqs_invoke_permission ? 1 : 0
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_queue_arn
}

resource "aws_lambda_permission" "eventbridge" {
  count         = var.enable_eventbridge_invoke_permission ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.eventbridge_rule_arn
}

resource "aws_lambda_permission" "sns" {
  count         = var.enable_sns_invoke_permission ? 1 : 0
  statement_id  = "AllowInvocationFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

resource "aws_lambda_permission" "cloudwatch_scheduler" {
  count         = var.enable_scheduler_invoke_permission ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = var.cloudwatch_scheduler_arn
}

# ------------------------------------------------------------------------------
# LAMBDA LOG RETENTION
# ------------------------------------------------------------------------------
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.logs_retention
}

# ------------------------------------------------------------------------------
# CREATE LAMBDA FUNCTION URL
# ------------------------------------------------------------------------------
resource "aws_lambda_function_url" "function_url" {
  count              = var.function_url ? 1 : 0
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"

  dynamic "cors" {
    for_each = length(keys(var.function_url_cors)) == 0 ? [] : [var.function_url_cors]

    content {
      allow_credentials = try(cors.value.allow_credentials, null)
      allow_headers     = try(cors.value.allow_headers, null)
      allow_methods     = try(cors.value.allow_methods, null)
      allow_origins     = try(cors.value.allow_origins, null)
      expose_headers    = try(cors.value.expose_headers, null)
      max_age           = try(cors.value.max_age, null)
    }
  }
}
