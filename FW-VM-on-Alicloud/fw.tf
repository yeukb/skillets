


# Launch Instance with Mgmt Interface
resource "alicloud_instance" "instance" {
  # ap-southeast-1
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  security_groups = ["${alicloud_security_group.FW-MGMT-SG.id}"]
  instance_type        = "${var.instance-type}"
  system_disk_size     = 60
  system_disk_category = "cloud_efficiency"
  image_id             = "${data.alicloud_images.images_ds.images.0.id}"
  instance_name        = "${var.instance-name}"
  vswitch_id = "${alicloud_vswitch.FW-vswitch-mgmt.id}"
  internet_max_bandwidth_out = 5
  private_ip = "${var.MGMT-IP}"
  host_name = "${var.instance-name}"
}

# Create Untrust Interface
resource "alicloud_network_interface" "eni1" {
    name = "${var.instance-name}-eni1"
    vswitch_id = "${alicloud_vswitch.FW-vswitch-untrust.id}"
    private_ip = "${var.UNTRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}


# Create Trust Interface
resource "alicloud_network_interface" "eni2" {
    name = "${var.instance-name}-eni2"
    vswitch_id = "${alicloud_vswitch.FW-vswitch-trust.id}"
    private_ip = "${var.TRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}

# Attach Untrust interface to Instance
resource "alicloud_network_interface_attachment" "untrust" {
    instance_id = "${alicloud_instance.instance.id}"
    network_interface_id = "${alicloud_network_interface.eni1.id}"

    depends_on = ["alicloud_instance.instance",
                  "alicloud_network_interface.eni1"]

}

# Attach Rrust interface to Instance
resource "alicloud_network_interface_attachment" "trust" {
    instance_id = "${alicloud_instance.instance.id}"
    network_interface_id = "${alicloud_network_interface.eni2.id}"

    depends_on = ["alicloud_instance.instance",
                  "alicloud_network_interface.eni2",
                  "alicloud_network_interface_attachment.untrust"]
}


