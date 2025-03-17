resource "aws_iam_role" "ec2_backup_role" {
  name = "ec2-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "backup_s3_policy" {
  name        = "BackupS3Policy"
  description = "Permitir a EC2 subir backups a S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "arn:aws:s3:::desafio-tecnico-ml-web/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_backup_policy" {
  role       = aws_iam_role.ec2_backup_role.name
  policy_arn = aws_iam_policy.backup_s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-backup-profile"
  role = aws_iam_role.ec2_backup_role.name
}
