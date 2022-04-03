provider "kubernetes" {
  config_path = "./kubeconfig"
}

resource "kubernetes_namespace" "k3s" {
  metadata {
    name = "k3s"
  }
}

resource "kubernetes_deployment" "k3s" {
  metadata {
    name = "k3s"
    labels = {
      app = "k3s"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "k3s"
      }
    }
    template {
      metadata {
        labels = {
          app = "k3s"
        }
      }
      spec {
        container {
          image = "pedroimpulcetto/ks3:latest"
          name  = "k3s-image"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
