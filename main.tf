provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

data "intersight_kubernetes_cluster" "kubeconfig" {
  name = var.clustername
}

provider "helm" {
  kubernetes {
    host = yamldecode(base64decode(data.intersight_kubernetes_cluster.kubeconfig.results[0].kube_config)).clusters[0].cluster.server
    client_certificate = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.kubeconfig.results[0].kube_config)).users[0].user.client-certificate-data)
    client_key = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.kubeconfig.results[0].kube_config)).users[0].user.client-key-data)
    cluster_ca_certificate = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.kubeconfig.results[0].kube_config)).clusters[0].cluster.certificate-authority-data)
  }
}

#resource "helm_release" "helloiksapp" {
#  name       = "helloiksapp"
#  namespace        = "iks-adp-namespace"
#  create_namespace = true
#  chart = "https://github.com/alessandro-deprato/devnet_3034_app/raw/master/helloiks_adp-0.1.1.tgz"
#  set {
#    name  = "MESSAGE"
#    value = "Hello IKS from TFCB!!"
#  }
#} 

