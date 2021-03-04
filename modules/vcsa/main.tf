locals {
  hostname          = join(".", [var.short_hostname, var.domain])
  sso_administrator = "administrator@${var.sso_domain_name}"
}

resource "random_password" "root_password" {
  length = 16
  special = true
}

resource "random_password" "administrator_password" {
  length = 16
  special = true
}

data "vsphere_ovf_vm_template" "ova" {
  name = var.short_hostname
  resource_pool_id = var.resource_pool_id
  datastore_id = var.datastore_id
  host_system_id = var.host_system_id
  local_ovf_path = var.ova_path
  deployment_option = var.deployment_size
  ovf_network_map = {
    "Network 1": var.network_id
  }
}

resource "vsphere_virtual_machine" "vcsa" {
  name             = data.vsphere_ovf_vm_template.ova.name
  datacenter_id    = var.datacenter_id
  folder           = var.folder_name
  resource_pool_id = data.vsphere_ovf_vm_template.ova.resource_pool_id
  host_system_id   = data.vsphere_ovf_vm_template.ova.host_system_id
  datastore_id     = data.vsphere_ovf_vm_template.ova.datastore_id

  num_cpus               = data.vsphere_ovf_vm_template.ova.num_cpus
  memory                 = data.vsphere_ovf_vm_template.ova.memory
  guest_id               = data.vsphere_ovf_vm_template.ova.guest_id
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true
  memory_hot_add_enabled = true
  scsi_type              = "lsilogic"
  enable_logging         = true

  network_interface {
    network_id     = var.network_id
    use_static_mac = var.mac_address == "" ? false : true
    mac_address    = var.mac_address
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
      "guestinfo.cis.appliance.net.addr.family" = "ipv4"
      "guestinfo.cis.appliance.net.mode"        = var.ip_address == "" ? "dhcp" : "static"
      "guestinfo.cis.appliance.net.addr"        = var.ip_address
      "guestinfo.cis.appliance.net.dns.servers" = var.dns
      "guestinfo.cis.appliance.net.prefix"      = var.prefix
      "guestinfo.cis.appliance.net.gateway"     = var.gateway
      "guestinfo.cis.appliance.net.pnid"        = local.hostname
      "guestinfo.cis.appliance.root.passwd"     = random_password.root_password.result
      "guestinfo.cis.vmdir.password"            = random_password.administrator_password.result

      //These properties require `enable_hidden_properties = true`
      //"guestinfo.cis.appliance.ssh.enabled" = title(tostring(var.enable_ssh))
      //"guestinfo.cis.deployment.autoconfig" = "True"
      //"guestinfo.cis.appliance.ntp.servers" = var.ntp
      //"guestinfo.cis.vmdir.domain-name"     = var.sso_domain_name
      //"guestinfo.cis.vmdir.username"        = local.sso_administrator
      //"guestinfo.cis.ceip_enabled"          = "False"
    }
  }

  # provisioner "local-exec" {
  #   command = "${path.module}/vcsa-provisioner.sh"
  #   environment = {
  #     VCENTER_HOSTNAME = local.hostname
  #     VCENTER_USERNAME = local.sso_administrator
  #     VCENTER_PASSWORD = random_password.administrator_password.result
  #     TIMEOUT          = var.provisioner_timeout
  #   }
  # }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
    ]
  }
}
