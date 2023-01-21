variable "resource_group" {
  type    = string
  default = "MyResource"
}

variable "virtual_network" {
  type        = string
  default     = "MyVirtualNetwork"
  description = "description"
}
variable "SubnetName" {
  type        = string
  default     = "SubnetA"
  description = "description"
}
variable "NetworkInterface" {
  type        = string
  default     = "Network"
  description = "description"
}
variable "StorageAccount" {
  type        = string
  default     = "mystorageabdo123"
  description = "description"
}

variable "StorageContainer" {
  type        = string
  default     = "storagecontainer"
  description = "description"
}

variable "VM" {
  type        = string
  default     = "vm1"
  description = "description"
}

variable "SshPath" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "description"
}

variable "PathStoreIp" {
  type        = string
  default     = "ip.txt"
  description = "description"
}


