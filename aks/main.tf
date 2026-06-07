# Minimal, secure-by-default AKS for ephemeral use:
# - System-assigned managed identity (no service principal, no secret to rotate)
# - Workload identity + OIDC issuer enabled (free, and the foundation for the
#   GitOps and secrets projects that consume this cluster later)
# - Azure CNI against a caller-provided subnet
# - Service CIDR pinned outside the vnet range to prevent overlap surprises
# - No prevent_destroy anywhere: this cluster exists to be destroyed

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-aks"
  sku_tier            = var.sku_tier
  kubernetes_version  = var.kubernetes_version

  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "system"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id
    os_disk_size_gb = var.os_disk_size_gb
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }

  tags = var.tags
}
