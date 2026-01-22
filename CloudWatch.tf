resource "aws_cloudwatch_log_group" "ssm_sessions" {
  name              = "/aws/ssm/session-manager"
  retention_in_days = 30

  tags = {
    Name = "ssm-session-logs"
  }
}

resource "aws_ssm_document" "session_manager_settings" {
  name          = "SSM-SessionManager"
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Session Manager settings with CloudWatch logging"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = aws_s3_bucket.vpc_logs.bucket
      s3KeyPrefix                 = "session-logs/"
      cloudWatchEncryptionEnabled = false
    }
  })
}


