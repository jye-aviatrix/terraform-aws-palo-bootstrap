variable "s3_bucket_name_prefix" {
  description = "Provide prefix for s3 bucket name"
  default = "palo-bootstrap"
  type = string
}

variable "role_name_prefix" {
  description = "Provide prefix for role name"
  default = "palo-bootstrap"
  type = string
}