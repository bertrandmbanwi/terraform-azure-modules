output "cluster_id" {
  description = "Resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the AKS cluster, for az aks get-credentials and verification."
  value       = azurerm_kubernetes_cluster.this.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL, consumed later for workload identity federation."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "kubelet_identity_object_id" {
  description = "Object ID of the kubelet managed identity, for ACR pull and similar role assignments."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "node_resource_group" {
  description = "Auto-created resource group holding the node VMSS and LB; useful for cost queries and janitor awareness."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
