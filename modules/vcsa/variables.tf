variable "ova_path" {
  type = string
  description = "The full path to the vCenter Server Appliance OVA."
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

variable "ip_address" {
  type = string
  description = "The IP address of the vCenter Server Appliance."
}

variable "mac_address" {
  type = string
  description = "The MAC address of the vCenter Server Appliance."
}

variable "cpu_count_override" {
  type        = number
  default     = 0
  description = "The number of CPUs the vCenter Server Appliance should have. Defaults to 0 which uses the CPU count of the deployment selected."

  validation {
    condition     = var.cpu_count_override >= 0
    error_message = "The cpu_count_override value must greater than or equal to 0."
  }
}

variable "memory_override" {
  type        = number
  default     = 0
  description = "The ammount of memory the vCenter Server Appliance should have. Defaults to 0 which uses the memory size of the deployment selected."

  validation {
    condition     = var.memory_override >= 0
    error_message = "The memory_override value must greater than or equal to 0."
  }
}

variable "deployment_size" {
  type        = string
  default     = "tiny"
  description = "The deployment size of the vCenter Server Appliances.  Defaults to \"tiny\"."
}

variable "short_hostname" {
  type = string
  description = "The short hostname of the vCenter Server Appliance"
}

variable "prefix" {
  type = number
  description = "The subnet of the vCenter Server Appliance in CIDR format."
}

variable "sso_domain_name" {
  type        = string
  default     = "vsphere.local"
  description = "The name of the internal SSO domain.  Defaults to \"vsphere.local\"."
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled on the vCenter Server Appliance?"
}

variable "provisioner_timeout" {
  type = number
  description = "The max amount of time to wait in minutes for the vCenter Server Appliance to become available after provisioning"
  default = 60
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
