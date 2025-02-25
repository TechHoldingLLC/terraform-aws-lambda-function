variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
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
  default     = {}
}

variable "description" {
  description = "Lambda function description"
  default     = null
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
  default     = null
}

variable "image_uri" {
  description = "uri of image"
  default     = null
}

variable "package_type" {
  description = "type of package"
  default     = null
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
  default     = null
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

variable "s3_key" {
  description = "Path of the zip file which is present in s3 bucket"
  default     = ""
}

variable "source_file" {
  description = "Lambda source file"
  default     = ""
}

variable "output_path" {
  description = "The name for the zip file created with the file described in source_file"
  default     = ""
}

variable "tags" {
  description = "Tags"
  default     = {}
}

variable "tracing_mode" {
  description = "Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active."
  type        = string
  default     = null
}

variable "image_config_entry_point" {
  description = "The ENTRYPOINT for the docker image"
  type        = list(string)
  default     = []
}

variable "image_config_command" {
  description = "The CMD for the docker image"
  type        = list(string)
  default     = []
}

variable "image_config_working_directory" {
  description = "The working directory for the docker image"
  type        = string
  default     = null
}

############################################
# Lambda Event Source Mapping
############################################

variable "event_source_mapping" {
  description = "Map of event source mapping"
  type        = any
  default     = {}
}