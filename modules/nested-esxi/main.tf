locals {
  split_hostname = split(".", var.hostname)
  short_hostname = local.split_hostname[0]
  domain = join(".",slice(local.split_hostname, 1, length(local.split_hostname)))
}

resource "random_password" "esxi_root_password" {
  length  = 16
  special = true
}

resource "vsphere_virtual_machine" "esxi" {
  name             = local.short_hostname
  datacenter_id    = var.datacenter_id
  folder           = var.folder_name
  resource_pool_id = var.resource_pool_id
  host_system_id   = var.host_system_id
  datastore_id     = var.datastore_id

  num_cpus            = var.cpu_count
  memory              = var.memory
  enable_disk_uuid    = true
  firmware            = "efi"
  nested_hv_enabled   = true
  sync_time_with_host = true
  enable_logging      = true

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 5

  network_interface {
    network_id     = var.network_id
    use_static_mac = var.mac_address == "" ? false : true
    mac_address    = var.mac_address
  }

  network_interface {
    network_id = var.network_id
  }

  cdrom {}

  ovf_deploy {
    local_ovf_path       = var.esxi_ova_path
    disk_provisioning    = "thin"
    ip_protocol          = "IPV4"
    ip_allocation_policy = "STATIC_MANUAL"

    ovf_network_map = {
      "VM Network" = var.network_id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname"   = var.hostname
      "guestinfo.ipaddress"  = var.ip_address
      "guestinfo.netmask"    = var.netmask
      "guestinfo.gateway"    = var.gateway
      "guestinfo.dns"        = var.dns
      "guestinfo.domain"     = local.domain
      "guestinfo.ntp"        = var.ntp
      "guestinfo.syslog"     = var.syslog
      "guestinfo.password"   = random_password.esxi_root_password.result
      "guestinfo.ssh"        = title(tostring(var.enable_ssh))
      "guestinfo.createvmfs" = title(tostring(!var.enable_vsan))
      "guestinfo.vlan"       = var.vlan_id
    }
  }

  provisioner "local-exec" {
    //wait for the first boot scripts to settle
    command = "sleep 120"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      password = random_password.esxi_root_password.result
      host     = self.default_ip_address
    }

    inline = [
      # explicitly set the hostname as the first boot script doesn't seem to work
      "esxcli system hostname set --fqdn=${var.hostname}",
      # configure DDNS
      "esxcli system settings advanced set -o /Misc/PreferredHostName -s ${var.hostname}",
      # flag disks for vSAN if enable_vsan is true
      var.enable_vsan ? "esxcli vsan storage tag add -d ${compact([for disk in self.disk : disk.device_address == "scsi:0:2" ? "naa.${replace(lower(disk.uuid), "-", "")}" : ""])[0]} -t capacityFlash" : "echo vSAN disabled, not configuring",
      # restart management interface for DDNS to take effect
      "esxcli network ip interface set -e false -i vmk0; esxcli network ip interface set -e true -i vmk0",
    ]
  }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
      annotation,
    ]
  }
}

data "tls_certificate" "nested_esxi_certificate" {
  url          = "https://${var.hostname}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.esxi,
  ]
}
