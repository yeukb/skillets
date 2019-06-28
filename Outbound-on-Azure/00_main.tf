# Configure the Microsoft Azure Provider
provider "azurerm" {
  # NOTE: Environment Variables can also be used for Service Principal authentication
  # Terraform also supports authenticating via the Azure CLI too.
  # see here for more info: http://terraform.io/docs/providers/azurerm/index.html

  # subscription_id = "954c5e98-51c5-4327-869c-863c1561a795"
  # client_id       = "..."
  # client_secret   = "..."
  # tenant_id       = "..."
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

# Create an availability set
resource "azurerm_availability_set" "demo" {
	name                         = "AS-FW"
	location                     = "${var.location}"
	resource_group_name          = "${var.resource_group_name}"
	platform_update_domain_count = "2"
  platform_fault_domain_count  = "2"
  managed                      = "true"

  depends_on = ["azurerm_resource_group.main"]
}

# Create NSG for Management interface
resource "azurerm_network_security_group" "mgmt" {
  name                = "Mgmt-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.AllowedSourceIPRange}"
    destination_address_prefix = "*"
  }

  depends_on = ["azurerm_resource_group.main"]
}

# Create NSG for Trust/Untrust interfaces
resource "azurerm_network_security_group" "dataplane" {
  name                = "AllowAll-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "Allow-All-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All-Out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = ["azurerm_resource_group.main"]
}

# Creating random string for use in DNS Labels and Storage Account
resource "random_id" "randomId" {
  keepers = {
      # Generate a new ID only when a new resource group is defined
      resource_group = "${var.resource_group_name}"
  }
  byte_length = 8
}