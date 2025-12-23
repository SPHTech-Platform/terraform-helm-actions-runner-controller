############################
##### Chart Variables ######
############################
variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "arc-runner-set"
}

variable "chart_name" {
  description = "Helm chart name to provision."
  type        = string
  default     = "gha-runner-scale-set"
}

variable "chart_repository" {
  description = "Helm repository for the chart."
  type        = string
  default     = "oci://ghcr.io/actions/actions-runner-controller-charts"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version."
  type        = string
  default     = "0.12.1"
}

variable "chart_namespace" {
  description = "Namespace to install the chart into."
  type        = string
  default     = "arc-runners"
}

variable "chart_namespace_create" {
  description = "Create the namespace if it does not yet exist."
  type        = bool
  default     = true
}

variable "chart_timeout" {
  description = "Timeout to wait for the Chart to be deployed."
  type        = number
  default     = 300
}

variable "max_history" {
  description = "Max History for Helm."
  type        = number
  default     = 20
}

##################################
#  Values For Runner Set
##################################
variable "github_config_url" {
  description = "githubConfigUrl is the GitHub url for where you want to configure runners"
  type        = string
  default     = "https://github.com/enterprises/singapore-press-holdings"
}

variable "github_token" {
  description = "Set Github PAT Token"
  type        = string
  default     = ""
}

variable "github_app_id" {
  description = "GitHub App ID. This can't be set at the same time as github_token"
  type        = string
  default     = ""
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID. This can't be set at the same time as github_token"
  type        = string
  default     = ""
}

variable "github_app_private_key" {
  description = "The multiline string of your GitHub App's private key. This can't be set at the same time as github_token"
  type        = string
  default     = ""
}

variable "container_mode_type" {
  description = "Set container type mode"
  type        = string
  default     = "dind"
}

variable "auth_method" {
  description = "GitHub authentication method to be deployed."
  type        = string
  default     = "pat"

  validation {
    condition     = contains(["github-app", "pat"], var.auth_method)
    error_message = "Only `github-app` or `pat` auth methods are supported."
  }
}

variable "min_runners" {
  description = "Minimum number of replicas of the runner set."
  type        = number
  default     = 1
}

variable "max_runners" {
  description = "Maxium number of replicas of the runner set."
  type        = number
  default     = 3
}

variable "runner_group" {
  description = "Runner group name"
  type        = string
  default     = "arc-runner-set"
}

variable "runner_scale_set_name" {
  description = "Runner scale set name"
  type        = string
  default     = "arc-runner-set"
}

# Default spec map for dind container mode
variable "template_spec_metadata_labels" {
  description = "Labels to be added to the pod template metadata."
  type        = any
  default     = {}
}

variable "controller_service_account" {
  description = "Service account for the controller."
  type        = map(any)
  default = {
    namespace = "arc-systems"
    name      = "actions-runner-controller"
  }
}

variable "topology_spread_constraints" {
  description = "Topology spread constraints for the pods."
  type        = any
  default     = []
}

variable "node_selector" {
  description = "Node selector for the pods."
  type        = any
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for the pods."
  type        = any
  default     = []
}

variable "affinity" {
  description = "Affinity for the pods."
  type        = any
  default     = {}
}

variable "template_spec_config_type" {
  description = "Configuration type for the pod template spec."
  type        = string
  default     = "custom"
}

variable "runner_resources" {
  description = "Compute resources (CPU and Memory) for the runner requests and limits"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })

  default = {
    requests = {
      cpu    = "1"
      memory = "2Gi"
    }
    limits = {
      cpu    = "1"
      memory = "2Gi"
    }
  }
}
