output "bootstrap_bucket_name" {
  value = aws_s3_bucket.bootstrap.bucket
}

output "iam_role" {
  value = aws_iam_role.bootstrap.name
}