data "terraform_remote_state" "terraform_aws" {
  backend = "local"

  config = {
    path = "../terraform-aws/terraform.tfstate"
  }
}

resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/aws/ec2/web-server-logs"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ec2_log_stream" {
  name           = "web-server-log-stream"
  log_group_name = aws_cloudwatch_log_group.ec2_logs.name
}

resource "aws_cloudwatch_log_metric_filter" "s3_errors_filter" {
  name           = "S3ErrorFilter"
  log_group_name = aws_cloudwatch_log_group.ec2_logs.name

  pattern = "{ $.errorCode = \"AccessDenied\" || $.errorCode = \"NoSuchBucket\" || $.status = 403 }"

  metric_transformation {
    name      = "S3ConnectionErrors"
    namespace = "EC2/S3Monitoring"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_error_alarm" {
  alarm_name          = "S3ConnectionErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  metric_name         = aws_cloudwatch_log_metric_filter.s3_errors_filter.metric_transformation[0].name
  namespace           = "EC2/S3Monitoring"
  statistic           = "Sum"
  period              = 300
  alarm_description   = "Alerta activada cuando se detectan errores de conexión con S3"
  alarm_actions       = [aws_sns_topic.s3_alerts.arn]
}

resource "aws_sns_topic" "s3_alerts" {
  name = "S3AlertsTopic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.s3_alerts.arn
  protocol  = "email"
  endpoint  = "maxi.dipauli@outlook.com"
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "CloudWatchLogsPolicy"
  description = "Permitir que EC2 envíe logs a CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.ec2_logs.arn}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_logs_policy" {
  role       = data.terraform_remote_state.terraform_aws.outputs.ec2_combined_role_name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

output "cloudwatch_log_group_name" {
  description = "Nombre del Log Group en CloudWatch"
  value       = aws_cloudwatch_log_group.ec2_logs.name
}

output "sns_topic_arn" {
  description = "ARN del SNS Topic para alertas"
  value       = aws_sns_topic.s3_alerts.arn
}
