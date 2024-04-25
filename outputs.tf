# --- lambda/outputs.tf ---
output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.lambda.function_name
}

output "invoke_arn" {
  description = "Lambda Invoke ARN"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.lambda.arn
}

output "function_url" {
  description = "Function url"
  value       = var.function_url ? aws_lambda_function_url.function_url[0].function_url : null
}

output "role_name" {
  description = "Role name"
  value       = aws_iam_role.lambda.name
}

output "role_arn" {
  description = "Role arn"
  value       = aws_iam_role.lambda.arn
}

output "lambda_config" {
  description = "Lambda Config"
  value       = aws_lambda_function.lambda
}