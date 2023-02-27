locals {
  name = "cert-manager"
  labels = {
    "app.kubernetes.io/name" = local.name
    "app.kubernetes.io/instance" = local.name
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/version" = terraform.version
  }
}


resource "kubernetes_namespace" "i" {
  metadata {
    name = local.name
    labels = local.labels
  }
}

resource "helm_release" "i" {
  depends_on = [kubernetes_namespace.i]
  namespace = kubernetes_namespace.i.metadata[0].name
  chart = "jetstack/cert-manager"
  repository = "https://charts.jetstack.io"
  name  = local.name
  version = "v1.5.3"

  set {
      name = "installCRDs"
      value = "true"
  }
}

