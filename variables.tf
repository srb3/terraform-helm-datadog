variable "chart" {
  description = "An object describing the helm release"
  type = object({
    name       = string
    repository = string
    chart      = string
    version    = string
  })
  default = {
    name       = "datadog"
    repository = "https://helm.datadoghq.com"
    chart      = "datadog"
    version    = null
    values     = {}
  }
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "values" {
  type    = string
  default = ""
}

variable "deploy_metrics_server" {
  type    = bool
  default = false
}
