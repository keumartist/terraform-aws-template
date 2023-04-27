output "lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "dead_letter_queue_arn" {
  value = aws_sqs_queue.lambda_deadletter_queue.arn
}
