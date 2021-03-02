resource "random_password" "esxi_root_password" {
  length = 16
  special = true
}

resource "vsphere_virtual_machine" "esxi" {
  for_each = var.hostname_ip_map

  name = each.key
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
    network_id = var.network_id
  }

  network_interface {
    network_id = var.network_id
  }

  cdrom {
    client_device = true
  }

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
      "guestinfo.hostname"   = "${each.key}.${var.domain}"
      "guestinfo.ipaddress"  = each.value
      "guestinfo.netmask"    = var.netmask
      "guestinfo.gateway"    = var.gateway
      "guestinfo.dns"        = var.dns
      "guestinfo.domain"     = var.domain
      "guestinfo.ntp"        = var.ntp
      "guestinfo.syslog"     = var.syslog
      "guestinfo.password"   = random_password.esxi_root_password.result
      "guestinfo.ssh"        = title(tostring(var.enable_ssh))
      "guestinfo.createvmfs" = title(tostring(!var.enable_vsan))

      #"guestinfo.vlan" = ""
      #"guestinfo.debug" = "True"
    }
  }

  provisioner "local-exec" {
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
      "esxcli system hostname set --fqdn=${each.key}.${var.domain}",
      # configure DDNS
      "esxcli system settings advanced set -o /Misc/PreferredHostName -s ${each.key}.${var.domain}",
      # "cat >> /etc/dhclient-vmk0.conf << EOF",
      # "interface vmk0 {",
      # "   supersede host-name \"${each.key}.${var.domain}\";",
      # "}",
      # "EOF",

      # flag disks for vSAN if enable_vsan is true
      var.enable_vsan ? "esxcli vsan storage tag add -d ${compact([ for disk in self.disk: disk.device_address == "scsi:0:2" ? "naa.${replace(lower(disk.uuid),"-","")}" : "" ])[0]} -t capacityFlash" : "echo vSAN disabled, not configuring",

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

data "tls_certificate" "nested_esxi_certificates" {
  for_each = var.hostname_ip_map

  url          = "https://${each.key}.${var.domain}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.esxi,
  ]
}
