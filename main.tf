data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.target_host_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.target_datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "outer-config" {
  source = "./modules/outer-config"

  datacenter_id           = data.vsphere_datacenter.dc.id
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  resource_pool_name      = var.resource_pool_name
  folder_name             = var.folder_name
}

module "nested-esxi-hosts" {
  source = "./modules/nested-esxi"

  datacenter_id    = data.vsphere_datacenter.dc.id
  folder_name      = var.folder_name
  network_id       = data.vsphere_network.network.id
  resource_pool_id = module.outer-config.resource_pool_id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  esxi_ova_path    = join("/", [var.ova_path, var.esxi_ova_filename])

  cpu_count = var.esxi_cpu_count
  memory = var.esxi_memory

  hostname_ip_map = var.esxi_hostname_ip_map
  dns             = var.dns
  domain          = var.domain
  gateway         = var.gateway
  netmask         = var.netmask
  ntp             = var.ntp
  syslog          = var.vcsa_ip_address

  enable_ssh  = var.esxi_enable_ssh
  enable_vsan = var.enable_vsan
}

module "vcsa" {
  source = "./modules/vcsa"

  datacenter_id    = data.vsphere_datacenter.dc.id
  folder_name      = var.folder_name
  network_id       = data.vsphere_network.network.id
  resource_pool_id = module.outer-config.resource_pool_id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  ova_path         = join("/", [var.ova_path, var.vcsa_ova_filename])

  cpu_count_override = var.vcsa_cpu_count_override
  memory_override    = var.vcsa_memory_override
  deployment_size    = var.vcsa_deployment_size

  short_hostname = var.vcsa_short_hostname
  dns            = var.dns
  domain         = var.domain
  prefix         = var.prefix
  gateway        = var.gateway
  ntp            = var.ntp
  ip_address     = var.vcsa_ip_address

  enable_ssh  = var.vcsa_enable_ssh

  provisioner_timeout = var.vcsa_provisioner_timeout
}

module "nsx-t" {
  source = "./modules/nsx-t"

  datacenter_id    = data.vsphere_datacenter.dc.id
  folder_name      = var.folder_name
  network_id       = data.vsphere_network.network.id
  resource_pool_id = module.outer-config.resource_pool_id
  host_system_id   = data.vsphere_host.host.id
  datastore_id     = data.vsphere_datastore.datastore.id
  ova_path         = join("/", [var.ova_path, var.nsxt_manager_ova_filename])

  cpu_count_override = var.nsxt_manager_cpu_count_override
  memory_override    = var.nsxt_manager_memory_override
  deployment_size    = var.nsxt_manager_deployment_size

  short_hostname = var.nsxt_manager_short_hostname
  dns            = var.dns
  domain         = var.domain
  netmask        = var.netmask
  gateway        = var.gateway
  ntp            = var.ntp
  ip_address     = var.nsxt_manager_ip_address

  enable_ssh      = var.nsxt_manager_enable_ssh
  enable_root_ssh = var.nsxt_manager_enable_root_ssh
}
