
output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}


#acces to k8s cluster 
resource "local_file" "kubeconfig" {
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
  filename = var.kube_path
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
}