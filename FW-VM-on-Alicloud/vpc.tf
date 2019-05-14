
resource "alicloud_vpc" "fw_vpc" {
  name        = "${var.fw-vpc}-${random_id.randomId.hex}"
  cidr_block  = "${var.fw-vpc-cidr}"
  description = "VPC for VM-Series on Alicloud"
}

resource "alicloud_vswitch" "FW-vswitch-mgmt" {
  name              = "FW-VSwitch-MGMT"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw-vswitch-mgmt-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "MGMT VSwitch for VM-Series"
}

resource "alicloud_vswitch" "FW-vswitch-untrust" {
  name              = "FW-VSwitch-UNTRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw-vswitch-untrust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "Untrust VSwitch for VM-Series"
}

resource "alicloud_vswitch" "FW-vswitch-trust" {
  name              = "FW-VSwitch-TRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw-vswitch-trust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "Trust VSwitch for VM-Series"
}

#resource "alicloud_eip" "FW-EIP" {
#  name                 = "FW-EIP"
#  description          = "Public IP assigned to FW"
#  bandwidth            = "1"
#  internet_charge_type = "PayByTraffic"
#}

resource "alicloud_security_group" "FW-MGMT-SG" {
  name        = "FW-MGMT-Security-Group"
  vpc_id      = "${alicloud_vpc.fw_vpc.id}"
  description = "Security Group for FW MGMT"
}

resource "alicloud_security_group_rule" "allow_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "allow_https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group" "FW-DATA-SG" {
  name        = "FW-DATA-Security-Group"
  vpc_id      = "${alicloud_vpc.fw_vpc.id}"
  description = "Security Group for FW DATA"
}

resource "alicloud_security_group_rule" "allow_all" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-DATA-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}


