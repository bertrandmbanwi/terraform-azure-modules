variable "name" {
  description = "Name prefix; cluster becomes '<name>-aks'."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,40}$", var.name))
    error_message = "Name must be 2-40 chars, lowercase alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "Azure region for the cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group for the cluster."
  type        = string
}

variable "subnet_id" {
  description = "Subnet resource ID for the node pool (Azure CNI assigns pod IPs from this subnet; size it /22 or larger)."
  type        = string
}

variable "node_count" {
  description = "Node count for the default pool. 1 is the minimum and the ephemeral default."
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 10
    error_message = "node_count must be between 1 and 10."
  }
}

variable "vm_size" {
  description = "Node VM size. B2s keeps a full lifecycle run at roughly a cent."
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version. null uses the AKS default for the region."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "Control plane tier. Free has no SLA and costs nothing; Standard is 0.10 USD/hour."
  type        = string
  default     = "Free"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "sku_tier must be Free or Standard."
  }
}

variable "tags" {
  description = "Tags for all resources. Include 'ephemeral' for the janitor."
  type        = map(string)
  default     = {}
}
