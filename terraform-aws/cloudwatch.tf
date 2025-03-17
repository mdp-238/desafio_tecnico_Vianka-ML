resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarma activada cuando la CPU excede el 70% durante 2 periodos consecutivos"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = element(aws_instance.web_servers[*].id, 0)
  }
}

resource "aws_sns_topic" "alerts" {
  name = "cpu-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "maxi.dipauli@outlook.com"
}
