## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_permission.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.cognito](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.lambda_service_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_object.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |
| [aws_ssm_parameter.env_vars_from_parameter_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigw_execution_arn"></a> [apigw\_execution\_arn](#input\_apigw\_execution\_arn) | Apigw execution arn | `list` | `[]` | no |
| <a name="input_cognito_pool_arn"></a> [cognito\_pool\_arn](#input\_cognito\_pool\_arn) | Cognito pool arn | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Lambda function description | `any` | n/a | yes |
| <a name="input_env_vars_from_parameter_store"></a> [env\_vars\_from\_parameter\_store](#input\_env\_vars\_from\_parameter\_store) | Lambda environment variables from SSM parameter store | `map(any)` | `{}` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment Variables for Lambda Functions | `map(any)` | `{}` | no |
| <a name="input_eventbridge_rule_arn"></a> [eventbridge\_rule\_arn](#input\_eventbridge\_rule\_arn) | Eventbridge rule arn | `string` | `""` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name | `any` | n/a | yes |
| <a name="input_function_url"></a> [function\_url](#input\_function\_url) | Create lambda function url | `bool` | `false` | no |
| <a name="input_function_url_cors"></a> [function\_url\_cors](#input\_function\_url\_cors) | Function url cors | `any` | `[]` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Name of Handler | `any` | n/a | yes |
| <a name="input_lambda_memory"></a> [lambda\_memory](#input\_lambda\_memory) | Required Memory for Lambda function | `number` | `128` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda language | `any` | n/a | yes |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Required Timeout for Lambda function | `number` | `5` | no |
| <a name="input_layers_arn"></a> [layers\_arn](#input\_layers\_arn) | Lambda layer arn | `list(string)` | `null` | no |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Specifies the number of days you want to retain log events in the specified log group | `number` | `null` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | The name for the zip file created with the file described in source\_file | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resources | `string` | `""` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Publish lambda function version | `bool` | `false` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Lambda artifacts bucket | `string` | `""` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | Path of the zip file which is present in s3 bucket | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security geoup id | `list(any)` | `null` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | Lambda source file | `string` | `""` | no |
| <a name="input_sqs_queue_arn"></a> [sqs\_queue\_arn](#input\_sqs\_queue\_arn) | SQS queue arn | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets | `list(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Lambda ARN |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function. |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | Function url |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Lambda Invoke ARN |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Role arn |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Role name |