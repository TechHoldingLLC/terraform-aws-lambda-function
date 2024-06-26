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
  allowed_triggers = {
    APIGatewayAny = {
      statement_id = "AllowAPIGWLambdaInvoke"
      principal    = "apigateway.amazonaws.com"       #you can pass either service or principal
      source_arn   = "arn:aws:execute-api:us-west-2:123456789123:aqnku8akd0/*/*/*"
    },
    APIGatewayDevPost = {
      service      = "apigateway"
      source_arn   = "arn:aws:execute-api:us-west-2:123456789123:aqnku8akd0/dev/POST/*"
    }
  }
  
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

## Create Lambda function from docker image
```
module "lambda_test" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-lambda-function.git"

  function_name                        = "my-lambda"
  lambda_timeout                       = 60 #seconds
  image_uri                            = "image_uri:image_tag"
  package_type                         = "Image"
  environment_variables = {
    BAR = "FOO"
  }
}
```

## Lambda Permission for allowed triggers
Lambda Permissions should be specified to allow certain resources to invoke Lambda Function.
[List of AWS Service Principals](https://gist.github.com/shortjared/4c1e3fe52bdfa47522cfe5b41e5d6f22)

The example below demonstrates how to configure various services to trigger a Lambda function.
```
module "lambda_function" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-lambda-function.git"

  # ...omitted for brevity

  allowed_triggers = {
    CognitoIdentityPool = {
      statement_id  = "AllowCognitoPoolLambdaInvoke"
      principal     = "cognito-idp.amazonaws.com"     # or service = "cognito-idp"
      source_arn    = var.cognito_pool_arn
    },
    APIGatewayAny = {
      statement_id = "AllowAPIGWLambdaInvoke"
      principal    = "apigateway.amazonaws.com"
      source_arn   = "arn:aws:execute-api:us-west-2:123456789123:aqnku8akd0/*/*/*"
    },
    APIGatewayDevPost = {
      service      = "apigateway"
      source_arn   = "arn:aws:execute-api:us-west-2:123456789123:aqnku8akd0/dev/POST/*"
    },
    SQS = {
      statement_id = "AllowExecutionFromSQS"
      service      = "sqs"                            # or prinicipal = "sqs.amazonaws.com"
      source_arn   = var.sqs_queue_arn
    },
    SNS = {
      statement_id = "AllowInvocationFromSNS"
      principal    = "sns.amazonaws.com"              # or service = "sns"
      source_arn    = var.sns_topic_arn
    },
    EventBridge = {
      statement_id = "AllowExecutionFromEventBridge"
      principal    = "events.amazonaws.com"           # or service = "events"
      source_arn   = var.eventbridge_rule_arn
    },
    CloudwarchScheduler = {
      principal  = "scheduler.amazonaws.com"          # or service = "scheduler"
      source_arn = var.cloudwatch_scheduler_arn
    }
  }
}
```