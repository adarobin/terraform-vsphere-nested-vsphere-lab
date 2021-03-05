output "root_password" {
  value     = random_password.root_password.result
  sensitive = true
}

output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "audit_password" {
  value     = random_password.audit_password.result
  sensitive = true
}