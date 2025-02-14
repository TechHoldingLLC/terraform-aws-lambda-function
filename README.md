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
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.function_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_permission.triggers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.lambda_service_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_object.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |
| [aws_ssm_parameter.env_vars_from_parameter_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_triggers"></a> [allowed\_triggers](#input\_allowed\_triggers) | Map of allowed triggers to create Lambda permissions | `map(any)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Lambda function description | `any` | `null` | no |
| <a name="input_env_vars_from_parameter_store"></a> [env\_vars\_from\_parameter\_store](#input\_env\_vars\_from\_parameter\_store) | Lambda environment variables from SSM parameter store | `map(any)` | `{}` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment Variables for Lambda Functions | `map(any)` | `{}` | no |
| <a name="input_event_source_mapping"></a> [event\_source\_mapping](#input\_event\_source\_mapping) | Map of event source mapping | `any` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name | `any` | n/a | yes |
| <a name="input_function_url"></a> [function\_url](#input\_function\_url) | Create lambda function url | `bool` | `false` | no |
| <a name="input_function_url_cors"></a> [function\_url\_cors](#input\_function\_url\_cors) | Function url cors | `any` | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Name of Handler | `any` | `null` | no |
| <a name="input_image_config_command"></a> [image\_config\_command](#input\_image\_config\_command) | The CMD for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_entry_point"></a> [image\_config\_entry\_point](#input\_image\_config\_entry\_point) | The ENTRYPOINT for the docker image | `list(string)` | `[]` | no |
| <a name="input_image_config_working_directory"></a> [image\_config\_working\_directory](#input\_image\_config\_working\_directory) | The working directory for the docker image | `string` | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | uri of image | `any` | `null` | no |
| <a name="input_lambda_memory"></a> [lambda\_memory](#input\_lambda\_memory) | Required Memory for Lambda function | `number` | `128` | no |
| <a name="input_lambda_runtime"></a> [lambda\_runtime](#input\_lambda\_runtime) | Lambda language | `any` | `null` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | Required Timeout for Lambda function | `number` | `5` | no |
| <a name="input_layers_arn"></a> [layers\_arn](#input\_layers\_arn) | Lambda layer arn | `list(string)` | `null` | no |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Specifies the number of days you want to retain log events in the specified log group | `number` | `null` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | The name for the zip file created with the file described in source\_file | `string` | `""` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | type of package | `any` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resources | `string` | `""` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Publish lambda function version | `bool` | `false` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Lambda artifacts bucket | `string` | `""` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | Path of the zip file which is present in s3 bucket | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security geoup id | `list(any)` | `null` | no |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | Lambda source file | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets | `list(any)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map` | `{}` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | Tracing mode of the Lambda Function. Valid value can be either PassThrough or Active. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Lambda ARN |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function. |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | Function url |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Lambda Invoke ARN |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Role arn |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Role name |


## License

Apache 2 Licensed. See [LICENSE](https://github.com/TechHoldingLLC/terraform-aws-lambda-function/blob/main/LICENSE) for full details.