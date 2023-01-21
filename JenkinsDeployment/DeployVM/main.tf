# Create an Azure resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = "eastus2"
}

# Create an Azure virtual network  (like vpc in aws )
resource "azurerm_virtual_network" "virtual_network" {
  name                =  var.virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# # Create a subnet within the virtual network that is a  range  of ip in virtual network 
resource "azurerm_subnet" "subnetA" {
  name                 = var.SubnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes       = ["10.0.1.0/24"]
}



# create public ip 

resource "azurerm_public_ip" "public_ip" {
  name                = var.NetworkInterface
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# # Create a network interface and associate it with the virtual machine's network interface
# Create Network Card for linux VM
resource "azurerm_network_interface" "NetworkInterface" {
  name                = "nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                           = "Internal"
    subnet_id                      = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  depends_on = [
    azurerm_public_ip.public_ip
  ]
}

# Create an Azure storage account

# resource "azurerm_storage_account" "StorageAccount" {
#   name                     = var.StorageAccount
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# # Create a storage container in the storage account  to persiste the data  of VM 
# resource "azurerm_storage_container" "StorageContainer" {
#   name                  = var.StorageContainer
#   storage_account_name  = azurerm_storage_account.StorageAccount.name
#   container_access_type = "private"
# }

# Create a network security group
resource "azurerm_network_security_group" "firewall" {
  name                = "firewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }


  security_rule {
    name                       = "Jenkins UI"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "VM" {
  depends_on = [azurerm_network_interface.NetworkInterface]
  name                  = var.VM
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.NetworkInterface.id]
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    
  }
  
  
   os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file(var.SshPath)
    }
  }

  tags = {
    environment = "production"
  }
} 

# attch security group
resource "azurerm_network_interface_security_group_association" "jenkins" {
  network_interface_id      = azurerm_network_interface.NetworkInterface.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}
# # Create a data disk for the Jenkins VM
# resource "azurerm_managed_disk" "datadisk" {
#   name                = "datadisk"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   storage_account_type = "Standard_LRS"
#   create_option = "Empty"
#   disk_size_gb = "10"
# }

# # Attach the data disk to the Jenkins VM

# resource "azurerm_virtual_machine_data_disk_attachment" "datadisk" {
#   virtual_machine_id = azurerm_virtual_machine.VM.id
#   managed_disk_id    = azurerm_managed_disk.datadisk.id
#   lun                = 0
#   caching            = "None"
#   create_option      = "Attach"
# }
