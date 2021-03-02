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
    type = string
    description = "The ID of the host system that the nested ESXi OVA will be initially deployed on."
}

variable "enable_ssh" {
  type        = bool
  description = "Should SSH be enabled on the ESXi hosts.  Must be set to `true` presently so provisioners can run."
  default     = true

  validation {
    condition     = var.enable_ssh == true
    error_message = "Presently, the enable_ssh value must be `true` so that provisioners can run against the nested ESXi hosts."
  }
}

variable "hostname_ip_map" {
  type        = map(string)
  description = "A map containing the short hostname of each ESXi host to be deployed as the key and the IP address as the value."
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
  description = "The amount of memory each ESXi host should have. The default (and minimum) is 8192.  Due to https://github.com/hashicorp/terraform-provider-vsphere/issues/1130, this does not do anything."
  
  validation {
    condition     = var.memory >= 8192
    error_message = "The memory value must greater than or equal to 8192."
  }
}

variable "enable_vsan" {
  type        = bool
  default     = true
  description = "Should vSAN be enabled on the nested ESXi hosts?"
}

variable "domain" {
  type = string
  description = "The DNS domain the nested ESXi hosts reside on. DNS records must exist ahead of provisioning."
}

variable "dns" {
  type = string
  description = "The DNS server for the nested ESXi hosts."
}

variable "ntp" {
  type = string
  description = "The NTP server for the nested ESXi hosts."
}

variable "netmask" {
  type = string
  description = "The netmask of the nested ESXi hosts."
}

variable "gateway" {
  type = string
  description = "The gateway of the nested ESXi hosts."
}

variable "syslog" {
  type = string
  description = "The syslog server the nested ESXi hosts should send logs to."
}
