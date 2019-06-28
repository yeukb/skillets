# Create UDR to route to EgressLB

resource "azurerm_route_table" "rtProtected" {
  name                = "RT-${var.protectedSubnetName}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  route {
    name                   = "Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.egressLBFrontEndAddress}"
  }

  depends_on = ["azurerm_subnet.trust"]
}
