variable "name" {
  description = "Name prefix for all network resources (e.g. 'platform-dev'). Used as '<name>-vnet', '<name>-<subnet>-nsg'."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,40}$", var.name))
    error_message = "Name must be 2-40 chars, lowercase alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "Azure region for all network resources."
  type        = string
}

variable "resource_group_name" {
  description = "Name of an existing resource group to deploy into. The module does not create resource groups; that is the consumer's responsibility."
  type        = string
}

variable "address_space" {
  description = "CIDR blocks for the virtual network (e.g. [\"10.10.0.0/16\"])."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "address_space must contain at least one valid CIDR block."
  }
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create, keyed by short name. Each subnet gets an NSG by
    default (create_nsg = false to opt out, e.g. for subnets where Azure
    services manage their own rules).
  EOT
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    create_nsg        = optional(bool, true)
  }))

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet must be defined."
  }
}

variable "tags" {
  description = "Tags applied to all resources. Include 'ephemeral' and 'project' keys for the janitor workflow and cost tracking."
  type        = map(string)
  default     = {}
}
