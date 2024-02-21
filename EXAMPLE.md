# Lambda
Below are the examples of calling this module.

## Create lambda resource with security group
Lambda function will be created from the zip file named lambda.zip uploaded in s3 bucket where key is path for zip file in the bucket. Function url is used for security and access control which can be set to false also. Environment variables can also be passed from parameter store if required. Secuirty group and subnet ids are passed as list if required.
```
module "lambda_test" {
  source                  = "./lambda"
  function_name           = "${var.prefix}-test-lambda"
  handler                 = "lambda.handler"
  lambda_runtime          = "python3.x"
  s3_bucket               = "${var.prefix}-test-lambda"
  s3_key                  = "lambda.zip"
  description             = "Lambda resource with security group"
  security_group_ids      = ["sg-1234567"]
  subnets                 = ["subnet-1", "subnet-2"] 
  function_url            = true
  function_url_cors = {
    allow_credentials = false
    allow_headers     = ["header-1", "header-2"] 
    allow_methods     = ["GET", "POST"]
    allow_origins = [ 
      "*"
    ]
  }
  environment_variables = {
    LOG_LEVEL = "info"
    BASE_URL  = "https://example.com/v1/info"
  }
  env_vars_from_parameter_store = {
    DB_HOST = "/${var.prefix}/DB_HOST"
    DB_NAME = "/${var.prefix}/DB_NAME"
    DB_PORT = "/${var.prefix}/DB_PORT"
  }
  logs_retention          = 14
}
```

## Allow apigw to invoke lambda
Api gateway will invoke the lambda function where function is created from zip file named lambda.zip uploaded in s3 bucket where key is path for zip file in the bucket. 
```
module "lambda_test" {
  source                       = "./lambda"
  function_name                = "${var.prefix}-test-lambda"
  handler                      = "lambda.handler"
  lambda_runtime               = "python3.x"
  s3_bucket                    = "${var.prefix}-test-lambda"
  s3_key                       = "lambda.zip"
  description                  = "Allow apigw to invoke lambda"
  enable_api_invoke_permission = true
  apigw_execution_arn          = "arn:aws:apigateway:region::resource-path-specifier" 
  logs_retention = 14
}
```

## Create Lambda function from zip file when source file is passed
Here a file named test.py is present in same directory and in output_path, we define the name for zip file which is created by test.py. Output_path will create zip file with name lambda.zip
```
module "lambda_test" {
  source                  = ".lambda"
  function_name           = "${var.prefix}-test-lambda"
  handler                 = "lambda.handler"
  lambda_runtime          = "python3.x"
  source_file             = "test.py"
  output_path             = "lambda.zip"
  lambda_artifacts_bucket = "${var.prefix}-test-lambda"
  description             = "Test lambda"
  logs_retention          = 14
}
```