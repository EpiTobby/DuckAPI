output "vm_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "ssh" {
  value = "ssh ${azurerm_linux_virtual_machine.vm.admin_username}@${azurerm_linux_virtual_machine.vm.public_ip_address}"
}