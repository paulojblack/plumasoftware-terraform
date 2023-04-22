resource "aws_cloudwatch_log_group" "ui_log_group" {
  name = "${var.project_name}_ui"
  retention_in_days = 14
}