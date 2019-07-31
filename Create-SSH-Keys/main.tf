provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}


resource "alicloud_key_pair" "alicloud_key" {
    key_name = "${var.key-name}"
    key_file = "${var.key-name}"
}

output "key_name" {
  value = "${alicloud_key_pair.alicloud_key.key_name}"
}

output "key_fingerprint" {
  value = "${alicloud_key_pair.alicloud_key.finger_print}"
}
