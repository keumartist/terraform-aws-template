resource "aws_lambda_function" "this" {
  filename                       = var.lambda_placeholder_path
  function_name                  = var.name
  handler                        = var.handler
  role                           = module.iam_role.arn
  runtime                        = var.runtime
  layers                         = var.layer
  memory_size                    = 512
  reserved_concurrent_executions = -1

  tracing_config {
    mode = "Active"
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_deadletter_queue.arn
  }

  tags = {
    "team" : "devops"
  }

}

resource "aws_sqs_queue" "lambda_deadletter_queue" {
  name                      = "${var.name}-deadletter-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    "team" : "devops"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/logs/lambda/${var.name}"
  retention_in_days = 3
}

module "iam_role" {
  source = "./iam-role"

  iam-role-name = var.name
}
