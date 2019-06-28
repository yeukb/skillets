# Create VM-FW1

# Create Interfaces for Linux test machine
resource "azurerm_network_interface" "Linux-VNIC0" {
  name                = "INT-Dev-Management"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ipconfig0"
    subnet_id                     = "${azurerm_subnet.protected.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_virtual_network.network"]
}


# Creating Storage Account for Boot Diagnostics for Serial Console access to the Linux VM

resource "azurerm_storage_account" "diag-storage-account" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  depends_on = ["random_id.randomId",
                "azurerm_resource_group.main"]
}


# Create VM-Linux
resource "azurerm_virtual_machine" "Linux" {
  name                  = "VM-Dev"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "VM-Dev-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "VM-Dev"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  network_interface_ids = ["${azurerm_network_interface.Linux-VNIC0.id}"]

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.diag-storage-account.primary_blob_endpoint}"
  }

  depends_on = ["azurerm_network_interface.Linux-VNIC0",
                "azurerm_storage_account.diag-storage-account"]
}


#output "Linux-eth0" {
#  value = "${azurerm_network_interface.Linux-VNIC0.private_ip_address}"
#}
