
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
   depends_on = [
   azurerm_virtual_machine.VM
  ]
}


resource "local_file" "ip" {
  depends_on = [
    azurerm_virtual_machine.VM
  ]
  filename = var.PathStoreIp
  content = azurerm_public_ip.public_ip.ip_address
}




