data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "my_cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.s3_bucket_logs.id}"
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  is_multi_region_trail = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.requests_logging.arn}:*"

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::EC2::Instance"
      values = ["${aws_launch_template.morsesrc.arn}/"] # get the logging from all the instances created from this tamplate
    }
  }
}

resource "aws_s3_bucket" "s3_bucket_logs" {
  bucket        = "trail"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::trail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::trail/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudwatch_log_group" "requests_logging" {
  name = "requests_logging"
}

