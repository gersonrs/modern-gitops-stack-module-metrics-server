#######################
## Standard variables
#######################

variable "argocd_project" {
  description = "Name of the Argo CD AppProject where the Application should be created. If not set, the Application will be created in a new AppProject only for this Application."
  type        = string
  default     = null
}

variable "argocd_labels" {
  description = "Labels to attach to the Argo CD Application resource."
  type        = map(string)
  default     = {}
}

variable "destination_cluster" {
  description = "Destination cluster where the application should be deployed."
  type        = string
  default     = "in-cluster"
}

variable "target_revision" {
  description = "Override of target revision of the application chart."
  type        = string
  default     = "v2.8.1" # x-release-please-version
}

variable "helm_values" {
  description = "Helm chart value overrides. They should be passed as a list of HCL structures."
  type        = any
  default     = []
}

variable "enable_service_monitor" {
  description = "Enable Prometheus ServiceMonitor in the Helm chart."
  type        = bool
  default     = false
}

variable "app_autosync" {
  description = "Automated sync options for the Argo CD Application resource."
  type = object({
    allow_empty = optional(bool)
    prune       = optional(bool)
    self_heal   = optional(bool)
  })
  default = {
    allow_empty = false
    prune       = true
    self_heal   = true
  }
}

variable "dependency_ids" {
  description = "IDs of the other modules on which this module depends on."
  type        = map(string)
  default     = {}
}

#######################
## Module variables
#######################

variable "resources" {
  description = <<-EOT
    Resource limits and requests for metrics-servers's pods. Follow the style on https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/[official documentation] to understand the format of the values.

    NOTE: These are the same values as the defaults on the Helm chart. Usually they guarantee good performance for most cluster configurations up to 100 nodes. See https://github.com/kubernetes-sigs/metrics-server?tab=readme-ov-file#scaling[the official documentation] for more information.
  EOT
  type = object({
    requests = optional(object({
      cpu    = optional(string, "100m")
      memory = optional(string, "256Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string, "256Mi")
    }), {})
  })
  default = {}
}

variable "kubelet_insecure_tls" {
  description = "Whether metrics-server should be configured to accept insecure TLS connections when kubelet does not have valit SSL certificates."
  type        = bool
  default     = false
}
