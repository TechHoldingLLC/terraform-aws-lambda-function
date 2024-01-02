variable "apigw_execution_arn" {
  description = "Apigw execution arn"
  default     = []
}

variable "env_vars_from_parameter_store" {
  description = "Lambda environment variables from SSM parameter store"
  type        = map(any)
  default     = {}
}

variable "function_url" {
  description = "Create lambda function url"
  type        = bool
  default     = false
}

variable "function_url_cors" {
  description = "Function url cors"
  type        = any
  default     = []
}

variable "description" {
  description = "Lambda function description"
}

variable "environment_variables" {
  type        = map(any)
  description = "Environment Variables for Lambda Functions"
  default     = {}
}

variable "function_name" {
  description = "Lambda function name"
}

variable "handler" {
  description = "Name of Handler"
}

variable "s3_bucket" {
  description = "Lambda artifacts bucket"
  default     = ""
}

variable "lambda_memory" {
  description = "Required Memory for Lambda function"
  default     = 128
}

variable "lambda_runtime" {
  description = "Lambda language"
}

variable "layers_arn" {
  description = "Lambda layer arn"
  type        = list(string)
  default     = null
}

variable "lambda_timeout" {
  description = "Required Timeout for Lambda function"
  default     = 5
}

variable "publish" {
  description = "Publish lambda function version"
  default     = false
}

variable "security_group_ids" {
  description = "Security geoup id"
  type        = list(any)
  default     = null
}

variable "subnets" {
  description = "Subnets"
  type        = list(any)
  default     = null
}

variable "cognito_pool_arn" {
  type        = string
  default     = ""
  description = "Cognito pool arn"
}

variable "logs_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = null
}

variable "prefix" {
  description = "Prefix for resources"
  type        = string
  default     = ""
}

variable "sqs_queue_arn" {
  description = "SQS queue arn"
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "Path of the zip file which is present in s3 bucket"
  default     = ""
}

variable "source_file" {
  description = "Lambda source file"
  default     = ""
}

variable "sns_topic_arn" {
  description = "SNS topic arn"
  type        = string
  default     = ""
}

variable "output_path" {
  description = "The name for the zip file created with the file described in source_file"
  default     = ""
}

variable "eventbridge_rule_arn" {
  description = "Eventbridge rule arn"
  default     = ""
}