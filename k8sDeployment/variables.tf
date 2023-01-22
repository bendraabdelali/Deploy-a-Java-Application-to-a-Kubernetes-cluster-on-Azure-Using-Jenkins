variable "resource_group" {
  type    = string
  default = "MyResource"
}

variable "location" {
  type = string
  
}

variable "cluster_name" {
  type = string

}

variable "kubernetes_version" {
  type = string

}

variable "worker" {
  type = number
}


variable "kube_path" {
  type        = string
  description = "path to store kube config file "
  default     = "C:\\Users\\abdelali\\.kube\\config"
}

variable namespace {
  type        = string
}

variable grafana_pass {
  type        = string
}

