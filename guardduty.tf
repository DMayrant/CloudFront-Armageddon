resource "aws_guardduty_detector" "guardduty_detector" {
  enable = true
}

resource "aws_guardduty_detector_feature" "runtime_monitoring" {
  detector_id = aws_guardduty_detector.guardduty_detector.id
  name        = "RUNTIME_MONITORING"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.guardduty_detector.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "malware_protection" {
  detector_id = aws_guardduty_detector.guardduty_detector.id
  name        = "EBS_MALWARE_PROTECTION"
  status      = "ENABLED"
}
