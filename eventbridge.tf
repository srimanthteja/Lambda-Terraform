#creating a resource for cron scheduler
resource "aws_cloudwatch_event_rule" "cron_scheduler" {
  name        = "my-cron-scheduler"
  description = "corn job scheduler for vettel_lambda function"

  schedule_expression = "rate(5 minutes)"
}

#resoruce for eventbridge targeting lambda 
resource "aws_cloudwatch_event_target" "vettel_lambda" {
  rule      = aws_cloudwatch_event_rule.cron_scheduler.name
  target_id = "vettel_lambda"
  arn       = aws_lambda_function.vettel_lambda.arn
}

#Creating permissions for eventbridge to invoke lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgetoInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.vettel_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_scheduler.arn
}