variable "ova_path" {
  type = string
  default = "./ova"
  description = "The path to where the OVAs required for deployment are stored. Defaults to ./ova"
}

variable "esxi_ova_filename" {
  type = string
  default = "Nested_ESXi7.0u1_Appliance_Template_v1.ova"
  description = "The filename of the ESXi OVA. This probably doesn't need to be changed unless you renamed the file or want to try a newer image."
}

variable "vcsa_ova_filename" {
  type = string
  default = "VMware-vCenter-Server-Appliance-7.0.1.00200-17327517_OVF10.ova"
  description = "The filename of the vCenter OVA. This probably doesn't need to be changed unless you renamed the file or want to try a newer image."
}

variable "datacenter_name" {
  type = string
  description = "The name of the datacenter that the nested environment will be created in."
}

variable "folder_name" {
  type = string
  default = "nested-esxi"
  description = "The name of the vm folder to create the nested environment in."
}

variable "network_name" {
  type = string
  default = "VM Network"
  description = "The name of the network to attach the nested environment to."
}

variable "cluster_name" {
  type = string
  description = "The name of the cluster to deploy the nested environment to. A resource pool will be created in the cluster to hold the environment."
}

variable "resource_pool_name" {
  type = string
  default = "nested-esxi"
  description = "The name of the resource pool being created for the nested environment."
}

variable "target_host_name" {
  type = string
  description = "The hostname of a machine in the cluster specified by `cluster_name`. This will be the host the OVAs are deployed to."
}

variable "target_datastore_name" {
  type = string
  description = "The name of the datastore to deploy the nested environment on."
}

variable "netmask" {
  type = string
  description = "The netmask of all machines created in the nested environment.  The CIDR value `prefix` should match."
}

variable "gateway" {
  type = string
  description = "The gateway of all machines created in the nested environment."
}

variable "dns" {
  type = string
  description = "The DNS server of all machines created in the nested environment."
}

variable "ntp" {
  type = string
  default = "pool.ntp.org"
  description = "The NTP server of all machines created in the nested environment."
}

variable "domain" {
  type = string
  description = "The DNS domain the nested machines will reside on. DNS records must exist ahead of provisioning."
}

variable "esxi_hostname_ip_map" {
  type = map(string)
  description = "A map containing the short hostname of each ESXi host to be deployed as the key and the IP address as the value."
}

variable "esxi_hostname_mac_map" {
  type = map(string)
  description = "A map containing the short hostname of each ESXi host to be deployed as the key and the MAC address as the value."
}

variable "esxi_cpu_count" {
  type = number
  default = 2
  description = "The number of CPUs each ESXi host should have."
}

variable "esxi_memory" {
  type = number
  default = 8192
  description = "The amount of memory each ESXi host should have. Due to https://github.com/hashicorp/terraform-provider-vsphere/issues/1130, this does not presently do anything. The OVA has 8192 set by default."
}

variable "esxi_enable_ssh" {
  type = bool
  default = true
  description = "Should SSH be enabled on the ESXi hosts.  Must be set to `true` presently so provisioners can run ."
}

variable "vcsa_cpu_count_override" {
  type = number
  default = 0
  description = "The number of CPUs the vCenter Server Appliance should have."
}

variable "vcsa_memory_override" {
  type = number
  default = 0
  description = "The amount of memory the vCenter Server Appliance should have."
}

variable "vcsa_deployment_size" {
  type = string
  default = "tiny"
  description = "The deployment size of the vCenter Server Appliances.  Defaults to \"tiny\"."
}

variable "vcsa_ip_address" {
  type = string
  description = "The IP address of the vCenter Server Appliance"
}

variable "vcsa_mac_address" {
  type        = string
  description = "The MAC address of the vCenter Server Appliance"
  default     = ""
}

variable "vcsa_short_hostname" {
  type = string
  description = "The short hostname of the vCenter Server Appliance"
}

variable "prefix" {
  type = number
  description = "The value of `netmask` in CIDR format."
}

variable "vcsa_sso_domain_name" {
  type = string
  default = "vsphere.local"
  description = "The name of the internal SSO domain.  Defaults to \"vsphere.local\"."
}

variable "vcsa_enable_ssh" {
  type = bool
  default = true
  description = "Should SSH be enabled on the vCenter Server Appliance"
}

variable "vcsa_provisioner_timeout" {
  type = number
  default = 60
  description = "The max amount of time to wait in minutes for the vCenter Server Appliance to become available after provisioning"
}

variable "enable_vsan" {
  type = bool
  default = true
  description = "Should vSAN be enabled on the nested cluster?"
}

variable "nested_datacenter_name" {
  type        = string
  default     = "Nested-Datacenter"
  description = "The name of the datacenter to create in the nested environment."
}

variable "nested_cluster_name" {
  type        = string
  default     = "Nested-Cluster"
  description = "The name of the cluster to create in the nested environment."
}

variable "vcsa_license_key" {
  type        = string
  description = "The license key for the vCenter Server Appliance."
  default     = ""
}

variable "esxi_license_key" {
  type        = string
  description = "The license key for the ESXi hosts."
  default     = ""
}

variable "vsan_license_key" {
  type        = string
  description = "The license key for vSAN."
  default     = ""
}

variable "nsxt_manager_short_hostname" {
  type = string
  description = "The short hostname of the NSX-t Manager Appliance"
}

variable "nsxt_manager_cpu_count_override" {
  type = number
  description = "The number of CPUs the NSX-t Manager Appliance should have."
  default = 0

}

variable "nsxt_manager_memory_override" {
  type = number
  description = "The amount of memory the NSX-t Manager Appliance should have."
  default = 0
}

variable "nsxt_manager_enable_root_ssh" {
  type = bool
  default = true
  description = "Should root logins be permitted over SSH to the NSX Manager Appliance?"
}

variable "nsxt_manager_enable_ssh" {
  type = bool
  default = true
  description = "Should SSH be enabled to the NSX Manager Appliance?"
}

variable "nsxt_manager_ip_address" {
  type = string
  description = "The IP address of the NSX-t Manager Appliance"
}

variable "vcsa_mac_address" {
  type        = string
  description = "The MAC address of the NSX-T Manager Appliance"
  default     = ""
}

variable "nsxt_audit_username" {
  type = string
  description = "The username of the default NSX-t audit user.  Defaults to \"audit\"."
  default = "audit"
}

variable "nsxt_admin_username" {
  type = string
  description = "The username of the default NSX-t administrator user.  Defaults to \"admin\"."
  default = "admin"
}

variable "nsxt_manager_deployment_size" {
  type = string
  description = "The deployment size of the NSX-t Manager Appliances.  Defaults to \"small\"."
  default = "small"
}

variable "nsxt_manager_ova_filename" {
  type = string
  default = "nsx-unified-appliance-3.1.0.0.0.17107212-le.ova"
  description = "The filename of the NSX-t Unified Appliance OVA. This probably doesn't need to be changed unless you renamed the file or want to try a newer image."
}
