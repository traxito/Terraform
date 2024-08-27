#information to display after resource creation

output "rg-name" {
  description = "outputs the rg name"
  value       = azurerm_resource_group.rg-alias.name
}

output "st-name" {
  description = "outputs the st name"
  value       = azurerm_storage_account.st-alias.name
}

output "vm-name" {
  description = "outputs the VM name"
  value       = azurerm_linux_virtual_machine.TerraformLinuxVM.name
}

output "PIP" {
  description = "outputs the PIP"
  value       = azurerm_public_ip.PIP.ip_address
}
