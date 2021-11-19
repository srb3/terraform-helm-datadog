resource "helm_release" "datadog" {
  name       = var.chart.name
  repository = var.chart.repository
  chart      = var.chart.chart
  version    = var.chart.version

  namespace = var.namespace
  values    = [var.values]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "kubernetes_service" "datadog-statsd" {
  metadata {
    name      = "datadog-statsd"
    namespace = var.namespace
    annotations = {
      name = "datadog-statsd"
    }
  }
  spec {
    selector = {
      app = "kong-datadog"
    }
    port {
      name        = "statsd"
      port        = 8125
      protocol    = "UDP"
      target_port = 8125
    }
    session_affinity = "None"
    type             = "ClusterIP"
  }
}

locals {
  metrics_server = templatefile("${path.module}/templates/metrics-server.yaml", {
  })
}

resource "helm_release" "metrics" {
  count      = var.deploy_metrics_server ? 1 : 0
  name       = "metrics-server"
  repository = "https://charts.helm.sh/stable"
  chart      = "metrics-server"
  namespace  = "kube-system"
  values     = [local.metrics_server]
}
