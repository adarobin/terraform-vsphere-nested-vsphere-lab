variable "datacenter_id" {
  type = string
  description = "The datacenter that will hold the folder and resource pool that contains the nested environment."
}

variable "folder_name" {
  type = string
  description = "The name of the vm folder to create.  The nested environment will be created inside of it."
}

variable "parent_resource_pool_id" {
  type = string
  description = "The parent ID of the resource pool or cluster under which the resource pool for the nested environment will be created."
}

variable "resource_pool_name" {
  type = string
  description = "The name of the resource pool being created for the nested environment."
}
