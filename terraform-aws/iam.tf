resource "aws_iam_role" "ec2_combined_role" {
  name = "EC2CombinedRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "backup_s3_policy" {
  name        = "BackupS3Policy"
  description = "Permitir a EC2 subir y listar backups en S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:ListBucket"]
        Resource = ["arn:aws:s3:::desafio-tecnico-ml-web", "arn:aws:s3:::desafio-tecnico-ml-web/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "EC2CloudWatchPolicy"
  description = "Permitir que EC2 envíe métricas a CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "cloudwatch:PutMetricData",
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_backup_policy" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.backup_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch" {
  role       = aws_iam_role.ec2_combined_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "ec2_combined_profile" {
  name = "EC2CombinedProfile"
  role = aws_iam_role.ec2_combined_role.name
}
