
# Create VM-FW1

# Create Public IP Addresses for VM-FW1
resource "azurerm_public_ip" "PublicIP_0" {
  name                         = "fw1-management-${random_id.randomId.hex}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 4
  domain_name_label            = "fw1-management-${random_id.randomId.hex}"
  sku                          = "Standard"

  depends_on = ["azurerm_resource_group.main"]
}

resource "azurerm_public_ip" "PublicIP_1" {
  name                         = "fw1-untrust-${random_id.randomId.hex}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 4
  sku                          = "Standard"

  depends_on = ["azurerm_resource_group.main"]
}


# Create Interfaces for VM-FW1
resource "azurerm_network_interface" "FW1-VNIC0" {
  name                = "INT-FW1-Management"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = "${azurerm_subnet.mgmt.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP_0.id}"
  }

  depends_on = ["azurerm_virtual_network.network",
                "azurerm_public_ip.PublicIP_0"]
}

resource "azurerm_network_interface" "FW1-VNIC1" {
  name                 = "INT-FW1-Untrust"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = "${azurerm_subnet.untrust.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP_1.id}"
  }

  depends_on = ["azurerm_virtual_network.network",
                "azurerm_public_ip.PublicIP_1"]
}

resource "azurerm_network_interface" "FW1-VNIC2" {
  name                 = "INT-FW1-Trust"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  enable_ip_forwarding = "true"

  ip_configuration {
    name                                    = "ipconfig0"
    subnet_id                               = "${azurerm_subnet.trust.id}"
    private_ip_address_allocation           = "dynamic"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.egress-lb.id}"]
  }

  depends_on = ["azurerm_virtual_network.network"]
}


resource "azurerm_network_interface_backend_address_pool_association" "FW1-Trust" {
  network_interface_id    = "${azurerm_network_interface.FW1-VNIC2.id}"
  ip_configuration_name   = "ipconfig0"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.egress-lb.id}"
}



# Create VM-FW1
resource "azurerm_virtual_machine" "FW1" {
  name                  = "VM-FW1"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.vmSize}"
  availability_set_id		= "${azurerm_availability_set.demo.id}"
  
  delete_os_disk_on_termination = true
  
  plan {
    name      = "${var.imageSku}"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    sku       = "${var.imageSku}"
    version   = "${var.imageVersion}"
  }

  storage_os_disk {
    name              = "VM-FW1-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "VM-FW1"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
    custom_data    = "${var.bootstrap == "yes" ? "${var.customdata}" : ""}"
  }

  primary_network_interface_id = "${azurerm_network_interface.FW1-VNIC0.id}"
  
  network_interface_ids = ["${azurerm_network_interface.FW1-VNIC0.id}",
                           "${azurerm_network_interface.FW1-VNIC1.id}",
                           "${azurerm_network_interface.FW1-VNIC2.id}",
                          ]

  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = ["azurerm_network_interface.FW1-VNIC0",
                "azurerm_network_interface.FW1-VNIC1",
                "azurerm_network_interface.FW1-VNIC2"]
}


# Create VM-FW2

# Create Public IP Addresses for VM-FW2
resource "azurerm_public_ip" "PublicIP_2" {
  name                         = "fw2-management-${random_id.randomId.hex}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 4
  domain_name_label            = "fw2-management-${random_id.randomId.hex}"
  sku                          = "Standard"

  depends_on = ["azurerm_resource_group.main"]
}

resource "azurerm_public_ip" "PublicIP_3" {
  name                         = "fw2-untrust-${random_id.randomId.hex}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  idle_timeout_in_minutes      = 4
  sku                          = "Standard"

  depends_on = ["azurerm_resource_group.main"]
}


# Create Interfaces for VM-FW2
resource "azurerm_network_interface" "FW2-VNIC0" {
  name                = "INT-FW2-Management"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = "${azurerm_subnet.mgmt.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP_2.id}"
  }

  depends_on = ["azurerm_virtual_network.network",
                "azurerm_public_ip.PublicIP_2"]
}

resource "azurerm_network_interface" "FW2-VNIC1" {
  name                 = "INT-FW2-Untrust"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  enable_ip_forwarding = "true"

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = "${azurerm_subnet.untrust.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicIP_3.id}"
  }

  depends_on = ["azurerm_virtual_network.network",
                "azurerm_public_ip.PublicIP_3"]
}

resource "azurerm_network_interface" "FW2-VNIC2" {
  name                 = "INT-FW2-Trust"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  enable_ip_forwarding = "true"

  ip_configuration {
    name                                    = "ipconfig0"
    subnet_id                               = "${azurerm_subnet.trust.id}"
    private_ip_address_allocation           = "dynamic"
#    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.egress-lb.id}"]
  }

  depends_on = ["azurerm_virtual_network.network"]
}


resource "azurerm_network_interface_backend_address_pool_association" "FW2-Trust" {
  network_interface_id    = "${azurerm_network_interface.FW2-VNIC2.id}"
  ip_configuration_name   = "ipconfig0"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.egress-lb.id}"
}


# Create VM-FW2
resource "azurerm_virtual_machine" "FW2" {
  name                  = "VM-FW2"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.vmSize}"
  availability_set_id		= "${azurerm_availability_set.demo.id}"
  
  delete_os_disk_on_termination = true
  
  plan {
    name      = "${var.imageSku}"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    sku       = "${var.imageSku}"
    version   = "${var.imageVersion}"
  }

  storage_os_disk {
    name              = "VM-FW2-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "VM-FW2"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
    custom_data    = "${var.bootstrap == "yes" ? "${var.customdata}" : ""}"
  }

  primary_network_interface_id = "${azurerm_network_interface.FW2-VNIC0.id}"
  
  network_interface_ids = ["${azurerm_network_interface.FW2-VNIC0.id}",
                           "${azurerm_network_interface.FW2-VNIC1.id}",
                           "${azurerm_network_interface.FW2-VNIC2.id}",
                          ]

  os_profile_linux_config {
    disable_password_authentication = false
  }

  depends_on = ["azurerm_network_interface.FW2-VNIC0",
                "azurerm_network_interface.FW2-VNIC1",
                "azurerm_network_interface.FW2-VNIC2"]
}


output "FW1-MGMT" {
  value = "${join("", list("https://", "${azurerm_public_ip.PublicIP_0.fqdn}"))}"
}

output "FW1-UNTRUST-PIP" {
  value = "${azurerm_public_ip.PublicIP_1.ip_address}"
}

#output "FW1-eth0" {
#  value = "${azurerm_network_interface.FW1-VNIC0.private_ip_address}"
#}

#output "FW1-eth1" {
#  value = "${azurerm_network_interface.FW1-VNIC1.private_ip_address}"
#}

#output "FW1-eth2" {
#  value = "${azurerm_network_interface.FW1-VNIC2.private_ip_address}"
#

output "FW2-MGMT" {
  value = "${join("", list("https://", "${azurerm_public_ip.PublicIP_2.fqdn}"))}"
}

output "FW2-UNTRUST-PIP" {
  value = "${azurerm_public_ip.PublicIP_3.ip_address}"
}

#output "FW2-eth0" {
#  value = "${azurerm_network_interface.FW2-VNIC0.private_ip_address}"
#}

#output "FW2-eth1" {
#  value = "${azurerm_network_interface.FW2-VNIC1.private_ip_address}"
#}

#output "FW2-eth2" {
#  value = "${azurerm_network_interface.FW2-VNIC2.private_ip_address}"
#}