#Create random string surfix for unique S3 bucket name
resource "random_string" "surfix" {
  length  = 8
  special = false
  upper   = false
}

# Create S3 bucket
resource "aws_s3_bucket" "bootstrap" {
  bucket = "${var.s3_bucket_name_prefix}-${random_string.surfix.result}"

}

# Create config folder in S3 bucket
resource "aws_s3_object" "folder_config" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "config/"
  acl    = "private"
}

# Create content folder in S3 bucket
resource "aws_s3_object" "folder_content" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "content/"
  acl    = "private"
}

# Create license folder in S3 bucket
resource "aws_s3_object" "folder_license" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "license/"
  acl    = "private"
}

# Create software folder in S3 bucket
resource "aws_s3_object" "folder_software" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "software/"
  acl    = "private"
}


# Upload bootstrap.xml to config folder
resource "aws_s3_object" "xml" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "config/bootstrap.xml"
  source = "config/bootstrap.xml"
}

#upload init-cfg.txt to config folder
resource "aws_s3_object" "init" {
  bucket = aws_s3_bucket.bootstrap.id
  key    = "config/init-cfg.txt"
  source = "config/init-cfg.txt"
}

# Construct policy document for FW instance to be able to assume role.
data "aws_iam_policy_document" "bootstrap_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#Create IAM role for the FW instance to use assume role policy document.
resource "aws_iam_role" "bootstrap" {
  name               = "${var.role_name_prefix}-${random_string.surfix.result}"
  assume_role_policy = data.aws_iam_policy_document.bootstrap_role.json
}

# Create IAM policy for FW instance to list bucket, and read bucket content.
resource "aws_iam_policy" "bootstrap" {
  name = "${var.role_name_prefix}-${random_string.surfix.result}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          "${aws_s3_bucket.bootstrap.arn}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.bootstrap.arn}/*"
        ]
      }
    ]
  })
}

# Attach IAM role with policy
resource "aws_iam_role_policy_attachment" "policy_role" {
  role       = aws_iam_role.bootstrap.name
  policy_arn = aws_iam_policy.bootstrap.arn
}

# Assign instance profile to the IAM role
resource "aws_iam_instance_profile" "instance_role" {
  name = "${var.role_name_prefix}-${random_string.surfix.result}" #Needs to match the iam_role_name for the Aviatrix controller to pick it up.
  role = aws_iam_role.bootstrap.name
}
