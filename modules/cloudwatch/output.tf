output "ui_log_group_name" {
  description = "The name of the CloudWatch Log Group for the UI service."
  value       = aws_cloudwatch_log_group.ui_log_group.name
}
