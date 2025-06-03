resource "helm_release" "argocd" {
  depends_on = [var.mod_dependency, kubernetes_namespace.argocd]
  count      = var.enabled ? length(var.helm_services) : 0
  name       = var.helm_services[count.index].name
  chart      = var.helm_services[count.index].release_name
  repository = var.helm_chart_repo
  version    = var.helm_services[count.index].chart_version
  namespace  = var.namespace
  skip_crds  = !var.install_crds

  set {
    name  = "installCRDs"
    value = var.install_crds
  }

  set { name = "installCRDs"   value = false }
  set { name = "crds.install"  value = false }

  set { name = "namespaced.enabled" value = true }

  values = [
    yamlencode(var.helm_services[count.index].settings),
    yamlencode(var.settings)
  ]
}
