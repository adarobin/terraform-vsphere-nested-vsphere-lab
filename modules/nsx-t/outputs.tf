output "manager_hostname" {
  value = local.manager_hostname
}

output "manager_root_password" {
  value = random_password.root_password.result
  sensitive = true
}

output "manager_admin_password" {
  value = random_password.admin_password.result
  sensitive = true
}

output "manager_audit_password" {
  value = random_password.audit_password.result
  sensitive = true
}