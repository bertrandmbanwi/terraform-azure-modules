# network

Virtual network with subnets and per-subnet NSGs (default-deny baseline).
Does not create resource groups; pass an existing one.

## Usage

module "network" {
  source = "git::https://github.com/bertrandmbanwi/terraform-azure-modules.git//network?ref=v0.1.0"

  name                = "platform-dev"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.platform.name
  address_space       = ["10.10.0.0/16"]

  subnets = {
    aks = {
      address_prefixes = ["10.10.0.0/22"]
    }
    endpoints = {
      address_prefixes  = ["10.10.4.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }

  tags = { project = "terraform-azure-platform", ephemeral = "true" }
}
