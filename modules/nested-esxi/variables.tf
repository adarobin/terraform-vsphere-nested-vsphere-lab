variable "esxi_ova_path" {
  type        = string
  description = "The full path to the ESXi OVA."
}

variable "folder_name" {
  type        = string
  description = "The name of the vm folder the nested ESXi Hosts should be created in."
}

variable "network_id" {
  type        = string
  description = "The ID of the network the nested ESXi Hosts should be attached to."
}

variable "datacenter_id" {
  type        = string
  description = "The ID of the dataceter the nested ESXi Hosts should be created in."
}

variable "resource_pool_id" {
  type        = string
  description = "The ID of the resource pool the nested ESXi Hosts should be created in."
}

variable "datastore_id" {
  type        = string
  description = "The ID of the datastore the nested ESXi Hosts should be created in."
}

variable "host_system_id" {
  type        = string
  description = "The ID of the host system that the nested ESXi OVA will be initially deployed on."
}

variable "enable_ssh" {
  type        = bool
  default     = true
  description = "Should SSH be enabled on the ESXi hosts.  Must be set to `true` presently so provisioners can run."

  validation {
    condition     = var.enable_ssh == true
    error_message = "Presently, the enable_ssh value must be `true` so that provisioners can run against the nested ESXi hosts."
  }
}

variable "hostname" {
  type        = string
  description = "The FQDN of the ESXi host. DNS records must exist ahead of provisioning or DDNS must be working in the environment."
}

variable "ip_address" {
  type        = string
  default     = ""
  description = "The IP address of the ESXi host. This defaults to \"\" which results in DHCP being used."
}

variable "mac_address" {
  type        = string
  default     = ""
  description = "The MAC address of the ESXi host. This defaults to \"\" which results in a MAC address being generated."
}

variable "cpu_count" {
  type        = number
  default     = 2
  description = "The number of CPUs each ESXi host should have.  The default (and minimum) is 2."

  validation {
    condition     = var.cpu_count >= 2
    error_message = "The cpu_count value must greater than or equal to 2."
  }
}

variable "memory" {
  type        = number
  default     = 8192
  description = "The amount of memory each ESXi host should have. The default (and minimum) is 8192."

  validation {
    condition     = var.memory >= 8192
    error_message = "The memory value must greater than or equal to 8192."
  }
}

variable "enable_vsan" {
  type        = bool
  default     = true
  description = "Should vSAN be enabled on the nested ESXi host?"
}

variable "domain" {
  type        = string
  default     = ""
  description = "The DNS domain the nested ESXi host resides on. This defaults to \"\" which results in DHCP being used. Must be set if a static IP is set in `ip_address`."
}

variable "dns" {
  type        = string
  default     = ""
  description = "The DNS server(s) for the nested ESXi host. This defaults to \"\" which results in DHCP being used. Must be set if a static IP is set in `ip_address`."
}

variable "ntp" {
  type        = string
  default     = "pool.ntp.org"
  description = "The NTP server for the nested ESXi host. Defaults to \"pool.ntp.org\"."
}

variable "netmask" {
  type        = string
  default     = ""
  description = "The netmask of the nested ESXi host. This defaults to \"\". Must be set if a static IP is set in `ip_address`."
}

variable "gateway" {
  type        = string
  default     = ""
  description = "The gateway of the nested ESXi host. This defaults to \"\". Must be set if a static IP is set in `ip_address`."
}

variable "syslog" {
  type        = string
  default     = ""
  description = "The syslog server the nested ESXi host should send logs to. Defaults to \"\" which results in remote syslog not being configured."
}

variable "vlan_id" {
  type        = number
  default     = null
  description = "The VLAN ID the management interface uses. Defaults to `null` which results in one not being configured."
}