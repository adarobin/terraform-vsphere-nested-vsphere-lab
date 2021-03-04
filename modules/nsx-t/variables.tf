variable "short_hostname" {
  type = string
  description = "The short hostname of the NSX-t Manager Appliance"
}

variable "folder_name" {
  type        = string
  description = "The name of the vm folder the vCenter Server Appliance should be created in."
}

variable "network_id" {
  type        = string
  description = "The ID of the network the vCenter Server Appliance should be attached to."
}

variable "datacenter_id" {
  type        = string
  description = "The ID of the dataceter the vCenter Server Appliance should be created in."
}

variable "resource_pool_id" {
    type        = string
    description = "The ID of the resource pool the vCenter Server Appliance should be created in."
}

variable "datastore_id" {
    type        = string
    description = "The ID of the datastore the vCenter Server Appliance should be created in."
}

variable "host_system_id" {
    type = string
    description = "The ID of the host system that the vCenter Server Appliance OVA will be initially deployed on."
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
  description = "Should root logins be permitted over SSH to the NSX Manager Appliance?"
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled to the NSX Manager Appliance?"
}

variable "ip_address" {
  type        = string
  description = "The IP address of the NSX-t Manager Appliance"
}

variable "mac_address" {
  type = string
  description = "The MAC address of the NSX-T Manager Appliance."
}

variable "audit_username" {
  type        = string
  default     = "audit"
  description = "The username of the NSX-t audit user. The default is \"audit\"."
}

variable "admin_username" {
  type        = string
  default     = "admin"
  description = "The username of the NSX-t admin user. The default is \"admin\"."
}

variable "deployment_size" {
  type        = string
  default     = "small"
  description = "The deployment size of the NSX-t Manager Appliance. The default is \"small\""
}

variable "ova_path" {
  type = string
  description = "The full path to the NSX-t Unified Appliance OVA."
}

variable "domain" {
  type = string
  description = "The DNS domain the vCenter Server Appliance resides on. DNS records must exist ahead of provisioning."
}

variable "dns" {
  type = string
  description = "The DNS server for the vCenter Server Appliance."
}

variable "ntp" {
  type = string
  description = "The NTP server for the vCenter Server Appliance."
}

variable "gateway" {
  type = string
  description = "The gateway of the vCenter Server Appliance."
}

variable "netmask" {
  type = string
  description = "The netmask of the nested ESXi hosts."
}
