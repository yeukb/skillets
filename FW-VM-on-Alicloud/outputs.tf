
# print public IP of Mgmt interface 
output "fw_public_ip" {
  value = "${alicloud_instance.instance.public_ip}"
}

