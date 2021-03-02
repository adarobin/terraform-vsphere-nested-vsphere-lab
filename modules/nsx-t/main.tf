locals {
  manager_hostname = join(".", [var.short_hostname, var.domain])
}

resource "random_password" "root_password" {
  length = 16
  special = true
}

resource "random_password" "admin_password" {
  length = 16
  special = true
}

resource "random_password" "audit_password" {
  length = 16
  special = true
}

data "vsphere_ovf_vm_template" "ova" {
  name              = var.short_hostname
  resource_pool_id  = var.resource_pool_id
  datastore_id      = var.datastore_id
  host_system_id    = var.host_system_id
  local_ovf_path    = var.ova_path
  deployment_option = var.deployment_size
  ovf_network_map   = {
    "Network 1": var.network_id
  }
}

resource "vsphere_virtual_machine" "nsxt_manager" {
  name             = data.vsphere_ovf_vm_template.ova.name
  datacenter_id    = var.datacenter_id
  folder           = var.folder_name
  resource_pool_id = data.vsphere_ovf_vm_template.ova.resource_pool_id
  host_system_id   = data.vsphere_ovf_vm_template.ova.host_system_id
  datastore_id     = data.vsphere_ovf_vm_template.ova.datastore_id

  num_cpus       = var.cpu_count_override > 0 ? var.cpu_count_override : data.vsphere_ovf_vm_template.ova.num_cpus
  memory         = var.memory_override > 0 ? var.memory_override : data.vsphere_ovf_vm_template.ova.memory
  guest_id       = data.vsphere_ovf_vm_template.ova.guest_id
  enable_logging = true

  network_interface {
    network_id = var.network_id
  }

  cdrom {
    client_device = true
  }

  ovf_deploy {
    local_ovf_path           = var.ova_path
    disk_provisioning        = "thin"
    ip_protocol              = "IPv4"
    
    ovf_network_map = {
      "Network 1" = var.network_id
    }
  }

  vapp {
    properties = {
      "nsx_passwd_0"           = random_password.root_password.result
      "nsx_cli_passwd_0"       = random_password.admin_password.result
      "nsx_cli_audit_passwd_0" = random_password.audit_password.result
      "nsx_cli_username"       = var.admin_username
      "nsx_cli_audit_username" = var.audit_username
      "nsx_hostname"           = local.manager_hostname
      "nsx_role"               = "NSX Manager"
      "nsx_gateway_0"          = var.gateway
      "nsx_ip_0"               = var.ip_address
      "nsx_netmask_0"          = var.netmask
      "nsx_dns1_0"             = var.dns
      "nsx_domain_0"           = var.domain
      "nsx_ntp_0"              = var.ntp
      "nsx_isSSHEnabled"       = title(tostring(var.enable_ssh))
      "nsx_allowSSHRootLogin"  = title(tostring(var.enable_root_ssh))
    }
  }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
    ]
  }
}

data "tls_certificate" "nsxt_manager_certificate" {
  url          = "https://${local.manager_hostname}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.nsxt_manager,
  ]
}
