variable "action_runner_scale_set_controller_chart_version" {
  description = "ARC Controller chart version"
  type        = string
  default     = "0.12.1"
}

variable "action_runner_scale_set_chart_version" {
  description = "ARC Scale set chart version"
  type        = string
  default     = "0.12.1"
}

variable "controller_helm_release_name" {
  description = "Helm release name for the controller"
  type        = string
  default     = "gha-controller"
}

variable "scale_set_release_name" {
  description = "Helm release name for the scale set"
  type        = string
  default     = "gha-scale-set"
}

variable "min_runners" {
  description = "Minimum number of runners to scale to"
  type        = number
  default     = 1
}

variable "max_runners" {
  description = "Maximum number of runners to scale to"
  type        = number
  default     = 3
}

variable "runner_scale_set_name" {
  description = "Name of the scale set"
  type        = string
}

variable "runner_group" {
  description = "Name of the runner group"
  type        = string
}

#####################
# k8s helm provider #
#####################

variable "k8s_token" {
  description = "Kubernetes token"
  type        = string
  sensitive   = true
}

variable "k8s_host" {
  description = "Kubernetes host"
  type        = string
}

variable "k8s_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  type        = string
  sensitive   = true
}

#######################
# Github Creds
#######################

variable "github_config_url" {
  description = "githubConfigUrl is the GitHub url for where you want to configure runners"
  type        = string
  # Please set to an GitHub Org URL or GitHub enterprise URL or repo url
}

variable "auth_method" {
  description = "values for auth method"
  type        = string
  default     = "github-app"
  validation {
    condition     = can(regex("^(github-app|pat)$", var.auth_method))
    error_message = "auth_method must be either github-app or pat"
  }
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

variable "github_token" {
  description = "Enterprise Runners' pat token of an enterprise admin user"
  type        = string
  default     = ""
}

variable "controller_node_selector" {
  description = "Node selector for the controller pod"
  type        = any
  default     = {}
}

variable "controller_tolerations" {
  description = "Tolerations for the controller pod"
  type        = any
  default     = []
}

variable "controller_affinity" {
  description = "Affinity for the controller pod"
  type        = any
  default     = {}
}

variable "controller_topology_spread_constraints" {
  description = "Topology spread constraints for the controller pod"
  type        = any
  default     = []
}

variable "runner_template_spec_config_type" {
  description = "Configuration type for the pod template spec."
  type        = string
  default     = "custom"
}

variable "runner_template_spec_metadata_labels" {
  description = "Labels to be added to the pod template metadata."
  type        = any
  default     = {}
}

variable "runner_template_spec_metadata_annotations" {
  description = "Annotations to be added to the pod template metadata."
  type        = map(string)
  default = {
    "karpenter.sh/do-not-disrupt" = "true"
  }
}

variable "runner_node_selector" {
  description = "Node selector for the runner pods"
  type        = any
  default     = {}
}

variable "runner_tolerations" {
  description = "Tolerations for the runner pods"
  type        = any
  default     = []
}

variable "runner_affinity" {
  description = "Affinity for the runner pods"
  type        = any
  default     = {}
}

variable "runner_topology_spread_constraints" {
  description = "Topology spread constraints for the runner pods"
  type        = any
  default     = []
}

variable "runner_container_mode_type" {
  description = "Container mode type for the runner pods, set to 'dind' to enable docker in docker or set to 'kubernetes' to use kubernetes mode or set null to use custom configs"
  type        = string
  default     = "dind"
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
      memory = "4Gi"
    }
    limits = {
      cpu    = "1"
      memory = "4Gi"
    }
  }
}
