variable "hostname" {
  type        = string
  description = "The FQDN of the NSX-T Manager Appliance. DNS records must exist ahead of provisioning or DDNS must be working in the environment"
}

variable "folder_name" {
  type        = string
  description = "The name of the vm folder the NSX-T Manager Appliance should be created in."
}

variable "network_id" {
  type        = string
  description = "The ID of the network the NSX-T Manager Appliance should be attached to."
}

variable "datacenter_id" {
  type        = string
  description = "The ID of the dataceter the NSX-T Manager Appliance should be created in."
}

variable "resource_pool_id" {
    type        = string
    description = "The ID of the resource pool the NSX-T Manager Appliance should be created in."
}

variable "datastore_id" {
    type        = string
    description = "The ID of the datastore the NSX-T Manager Appliance should be created in."
}

variable "host_system_id" {
    type        = string
    description = "The ID of the host system that the NSX-T Manager Appliance OVA will be initially deployed on."
}

variable "cpu_count_override" {
  type        = number
  default     = 0
  description = "The number of CPUs the NSX-t Manager Appliance should have. Defaults to 0 which uses the CPU count of the deployment selected."

  validation {
    condition     = var.cpu_count_override >= 0
    error_message = "The cpu_count_override value must greater than or equal to 0."
  }
}

variable "memory_override" {
  type        = number
  default     = 0
  description = "The ammount of memory the NSX-t Manager Appliance should have. Defaults to 0 which uses the memory size of the deployment selected."

  validation {
    condition     = var.memory_override >= 0
    error_message = "The memory_override value must greater than or equal to 0."
  }
}

variable "enable_root_ssh" {
  type        = bool
  default     = true
  description = "Should root logins be permitted over SSH to the NSX-T Manager Appliance?"
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled to the NSX-T Manager Appliance?"
}

variable "ip_address" {
  type        = string
  description = "The IP address of the NSX-T Manager Appliance"

  validation {
    condition = var.ip_address != ""
    error_message = "The ip_address must be set, DHCP is not allowed for the NSX-T Manager Appliance."
  }
}

variable "mac_address" {
  type        = string
  description = "The MAC address of the NSX-T Manager Appliance."
}

variable "audit_username" {
  type        = string
  default     = "audit"
  description = "The username of the NSX-T audit user. The default is \"audit\"."
}

variable "admin_username" {
  type        = string
  default     = "admin"
  description = "The username of the NSX-T admin user. The default is \"admin\"."
}

variable "deployment_size" {
  type        = string
  default     = "small"
  description = "The deployment size of the NSX-T Manager Appliance. The default is \"small\""

  validation {
    condition     = contains(["small", "medium", "large"], var.deployment_size)
    error_message = "The deployment_size must be one of \"small\", \"medium\", or \"large\"."
  }
}

variable "ova_path" {
  type        = string
  description = "The full path to the NSX-T Unified Appliance OVA."
}

variable "dns" {
  type        = string
  description = "The DNS server for the NSX-T Manager Appliance."

  validation {
    condition     = var.dns != ""
    error_message = "The value for dns must be set in order to deploy the NSX-T Manager Appliance."
  }
}

variable "ntp" {
  type        = string
  description = "The NTP server for the NSX-T Manager Appliance."
}

variable "gateway" {
  type        = string
  description = "The gateway of the NSX-T Manager Appliance."

  validation {
    condition     = var.gateway != ""
    error_message = "The gateway must be set in order to deploy the NSX-T Manager Appliance."
  }
}

variable "netmask" {
  type        = string
  description = "The netmask of the nested ESXi hosts."

  validation {
    condition     = var.netmask != ""
    error_message = "The netmask must be set in order to deploy the NSX-T Manager Appliance."
  }
}
