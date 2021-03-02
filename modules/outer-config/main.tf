resource "vsphere_folder" "folder" {
  path          = var.folder_name
  type          = "vm"
  datacenter_id = var.datacenter_id
}

resource "vsphere_resource_pool" "resource_pool" {
  name                    = var.resource_pool_name
  parent_resource_pool_id = var.parent_resource_pool_id

  depends_on = [
    // make the resource pool depend on the folder so that everything that uses the id of the resource pool also depends on the folder existing
    // this is because the folder is referenced by name, not ID
    vsphere_folder.folder,
  ]
}
