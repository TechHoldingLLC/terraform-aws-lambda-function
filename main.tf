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
  source_code_hash  = try(data.aws_s3_object.lambda[0].metadata.source_code_hash, data.archive_file.lambda[0].output_base64sha256, null)
  filename          = try(data.archive_file.lambda[0].output_path, null)
  image_uri         = var.image_uri
  package_type      = var.package_type
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

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "image_config" {
    for_each = length(var.image_config_entry_point) > 0 || length(var.image_config_command) > 0 || var.image_config_working_directory != null ? [true] : []
    content {
      entry_point       = var.image_config_entry_point
      command           = var.image_config_command
      working_directory = var.image_config_working_directory
    }
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------------------
# ASSIGN PERMISSION TO API GATEWAY, COGNITO, SQS, SNS, Cloudwatch Scheduler AND EVENTBRIDGE
# ------------------------------------------------------------------------------------------

resource "aws_lambda_permission" "triggers" {
  for_each = { for k, v in var.allowed_triggers : k => v }

  function_name = aws_lambda_function.lambda.function_name

  statement_id = try(each.value.statement_id, format("Allow%sLambdaInvoke", try(each.key, "")))
  action       = "lambda:InvokeFunction"
  principal    = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  source_arn   = try(each.value.source_arn, null)

  lifecycle {
    create_before_destroy = true
  }
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

# ------------------------------------------------------------------------------
# LAMBDA EVENT SOURCE MAPPING
# ------------------------------------------------------------------------------
resource "aws_lambda_event_source_mapping" "this" {
  for_each = { for k, v in var.event_source_mapping : k => v }

  function_name = aws_lambda_function.lambda.arn

  event_source_arn = try(each.value.event_source_arn, null)

  batch_size                         = try(each.value.batch_size, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, null)
  enabled                            = try(each.value.enabled, true)
  starting_position                  = try(each.value.starting_position, null)
  starting_position_timestamp        = try(each.value.starting_position_timestamp, null)
  parallelization_factor             = try(each.value.parallelization_factor, null)
  maximum_retry_attempts             = try(each.value.maximum_retry_attempts, null)
  maximum_record_age_in_seconds      = try(each.value.maximum_record_age_in_seconds, null)
  bisect_batch_on_function_error     = try(each.value.bisect_batch_on_function_error, null)
  function_response_types            = try(each.value.function_response_types, null)
  tumbling_window_in_seconds         = try(each.value.tumbling_window_in_seconds, null)

  dynamic "destination_config" {
    for_each = try(each.value.destination_arn_on_failure, null) != null ? [true] : []
    content {
      on_failure {
        destination_arn = each.value["destination_arn_on_failure"]
      }
    }
  }

  dynamic "scaling_config" {
    for_each = try([each.value.scaling_config], [])
    content {
      maximum_concurrency = try(scaling_config.value.maximum_concurrency, null)
    }
  }

  dynamic "filter_criteria" {
    for_each = try(each.value.filter_criteria, null) != null ? [true] : []

    content {
      dynamic "filter" {
        for_each = try(flatten([each.value.filter_criteria]), [])

        content {
          pattern = try(filter.value.pattern, null)
        }
      }
    }
  }

  dynamic "document_db_event_source_config" {
    for_each = try(each.value.document_db_event_source_config, [])

    content {
      database_name   = document_db_event_source_config.value.database_name
      collection_name = try(document_db_event_source_config.value.collection_name, null)
      full_document   = try(document_db_event_source_config.value.full_document, null)
    }
  }

  dynamic "metrics_config" {
    for_each = try([each.value.metrics_config], [])

    content {
      metrics = metrics_config.value.metrics
    }
  }

  dynamic "provisioned_poller_config" {
    for_each = try([each.value.provisioned_poller_config], [])
    content {
      maximum_pollers = try(provisioned_poller_config.value.maximum_pollers, null)
      minimum_pollers = try(provisioned_poller_config.value.minimum_pollers, null)
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}))
}