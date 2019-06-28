# Create a virtual network
resource "azurerm_virtual_network" "network" {
  name                = "${var.virtualNetworkName}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.virtualNetworkAddressPrefix}"]

  depends_on = ["azurerm_resource_group.main"]
}

#Create subnets
resource "azurerm_subnet" "mgmt" {
    name                      = "${var.managementSubnetName}"
    resource_group_name       = "${var.resource_group_name}"
    address_prefix            = "${var.managementSubnetAddressPrefix}"
    virtual_network_name      = "${azurerm_virtual_network.network.name}"
#    network_security_group_id = "${azurerm_network_security_group.mgmt.id}"

    depends_on = ["azurerm_virtual_network.network"]
}

resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = "${azurerm_subnet.mgmt.id}"
  network_security_group_id = "${azurerm_network_security_group.mgmt.id}"
}


resource "azurerm_subnet" "untrust" {
    name                      = "${var.untrustSubnetName}"
    resource_group_name       = "${var.resource_group_name}"
    address_prefix            = "${var.untrustSubnetAddressPrefix}"
    virtual_network_name      = "${azurerm_virtual_network.network.name}"
#    network_security_group_id = "${azurerm_network_security_group.dataplane.id}"

    depends_on = ["azurerm_virtual_network.network"]
}


resource "azurerm_subnet_network_security_group_association" "untrust" {
  subnet_id                 = "${azurerm_subnet.untrust.id}"
  network_security_group_id = "${azurerm_network_security_group.dataplane.id}"
}


resource "azurerm_subnet" "trust" {
    name                      = "${var.trustSubnetName}"
    resource_group_name       = "${var.resource_group_name}"
    address_prefix            = "${var.trustSubnetAddressPrefix}"
    virtual_network_name      = "${azurerm_virtual_network.network.name}"
#    network_security_group_id = "${azurerm_network_security_group.dataplane.id}"

    depends_on = ["azurerm_virtual_network.network"]
}


resource "azurerm_subnet_network_security_group_association" "trust" {
  subnet_id                 = "${azurerm_subnet.trust.id}"
  network_security_group_id = "${azurerm_network_security_group.dataplane.id}"
}


resource "azurerm_subnet" "protected" {
    name                      = "${var.protectedSubnetName}"
    resource_group_name       = "${var.resource_group_name}"
    address_prefix            = "${var.protectedSubnetAddressPrefix}"
    virtual_network_name      = "${azurerm_virtual_network.network.name}"
#    network_security_group_id = "${azurerm_network_security_group.dataplane.id}"
#    route_table_id            = "${azurerm_route_table.rtProtected.id}"

    depends_on = ["azurerm_virtual_network.network",
                  "azurerm_route_table.rtProtected"]
}


resource "azurerm_subnet_network_security_group_association" "protected" {
  subnet_id                 = "${azurerm_subnet.protected.id}"
  network_security_group_id = "${azurerm_network_security_group.dataplane.id}"
}


resource "azurerm_subnet_route_table_association" "protected" {
  subnet_id      = "${azurerm_subnet.protected.id}"
  route_table_id = "${azurerm_route_table.rtProtected.id}"
}

