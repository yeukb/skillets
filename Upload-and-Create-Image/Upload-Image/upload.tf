provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}


resource "alicloud_oss_bucket" "bucket_name" {
  bucket = "${var.bucket_name}"
  acl    = "private"
}


resource "alicloud_oss_bucket_object" "image_file" {
  bucket = "${var.bucket_name}"
  key    = "${var.image_key}"
  source = "${var.image_file}"

  depends_on = ["alicloud_oss_bucket.bucket_name"]
}


