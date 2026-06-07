# Virtual network and subnets with a default-deny security posture.
# Each subnet receives its own NSG unless opted out, relying on Azure's
# built-in NSG rules (VNet-to-VNet allowed, inbound internet denied) as the
# baseline. Consumers add workload-specific rules on top via the exported
# NSG IDs rather than this module guessing at application traffic.

resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = "${var.name}-${each.key}-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

locals {
  nsg_subnets = { for k, v in var.subnets : k => v if v.create_nsg }
}

resource "azurerm_network_security_group" "this" {
  for_each = local.nsg_subnets

  name                = "${var.name}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.nsg_subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}
