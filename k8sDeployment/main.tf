
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}



# create k8s 
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name
  default_node_pool {
    name                = "system"
    node_count          = var.worker
    vm_size             = "Standard_DS2_v2" 
    type                = "VirtualMachineScaleSets"
    # availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" # CNI
  }
}


#monitoring 
#  helm install prometheus prometheus-community/kube-prometheus-stack -f C:\Users\abdelali\Desktop\prometheus.yaml
# resource "kubernetes_namespace" "monitoring" {
#   depends_on=[
#     azurerm_kubernetes_cluster.aks
#   ]
#   metadata {
#     name = var.namespace
#   }
# }

# resource "helm_release" "prometheus" {
#   depends_on = [
#     local_file.kubeconfig,
#     kubernetes_namespace.monitoring
#   ]
#   chart      = "kube-prometheus-stack"
#   name       = "prometheus"
#   namespace  = var.namespace
#   repository = "https://prometheus-community.github.io/helm-charts"

#   set {
#     name  = "nameOverride"
#     value = "prometheus"
#   }
#   set {
#     name  = "namespaceOverride"
#     value = var.namespace
#   }
#   set {
#     name  = "grafana.adminPassword"
#     value = var.grafana_pass
#   }

#   set{
#     name="grafana.ingress.enabled"
#     value = "true"
#   }
 
# }


# 