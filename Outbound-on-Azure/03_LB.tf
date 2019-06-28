# Create an egress load balancer

resource "azurerm_lb" "egress-lb" {
  name                = "LB-Egress"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LB-Egress-FrontEnd"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.trust.id}"
    private_ip_address            = "${var.egressLBFrontEndAddress}"
  }

  depends_on = ["azurerm_subnet.trust"]
}

# Create a back end pool
resource "azurerm_lb_backend_address_pool" "egress-lb" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.egress-lb.id}"
  name                = "fw-trust-pool"

  depends_on = ["azurerm_lb.egress-lb"]
}

# Create a LB probe
resource "azurerm_lb_probe" "egress-lb" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.egress-lb.id}"
  name                = "TCP-22"
  protocol            = "TCP"
  port                = 22
  interval_in_seconds = 5
  number_of_probes 	  = 2

  depends_on = ["azurerm_lb.egress-lb"]
}

# Create LB Rules
resource "azurerm_lb_rule" "egress-lb" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.egress-lb.id}"
  name                           = "Allow-All-Out"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "LB-Egress-FrontEnd"
  backend_address_pool_id	       = "${azurerm_lb_backend_address_pool.egress-lb.id}"
  probe_id                       = "${azurerm_lb_probe.egress-lb.id}"
  load_distribution			         = "Default"
  enable_floating_ip             = "true"

  depends_on = ["azurerm_lb_backend_address_pool.egress-lb",
                "azurerm_lb_probe.egress-lb"]
}
