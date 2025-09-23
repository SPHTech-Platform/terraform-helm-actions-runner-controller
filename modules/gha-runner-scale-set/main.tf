resource "helm_release" "scale_set_release" {
  name             = var.release_name
  chart            = var.chart_name
  repository       = var.chart_repository
  version          = var.chart_version
  namespace        = var.chart_namespace
  create_namespace = var.chart_namespace_create

  max_history = var.max_history
  timeout     = var.chart_timeout

  values = [templatefile("${path.module}/templates/values.yaml", local.values)]

}

locals {
  values = {

    min_runners           = var.min_runners
    max_runners           = var.max_runners
    runner_group          = var.runner_group
    runner_scale_set_name = var.runner_scale_set_name

    github_config_url = var.github_config_url

    auth_method = var.auth_method

    github_app_id              = var.github_app_id
    github_app_installation_id = var.github_app_installation_id
    github_app_private_key     = var.github_app_private_key
    github_token               = var.github_token

    container_mode_type        = var.container_mode_type
    listener_template_spec     = yamlencode(local.listener_template_spec)
    template_spec_config_type  = var.template_spec_config_type
    template_spec              = yamlencode(local.template_spec)
    controller_service_account = yamlencode(var.controller_service_account)
  }

  listener_template_spec = {
    metadata = {
      annotations = {
        "prometheus.io/scrape" = "true"
        "prometheus.io/path"   = "/metrics"
        "prometheus.io/port"   = "8080"
      }
      labels = {}
    }
    spec = {
      nodeSelector = var.node_selector
      tolerations  = var.tolerations
      affinity     = var.affinity

      containers = [
        {
          name = "listener"
        }
      ]
    }
  }

  template_spec = {
    metadata = {
      labels = var.template_spec_metadata_labels
    }
    spec = {
      topologySpreadConstraints = var.topology_spread_constraints
      nodeSelector              = var.node_selector
      tolerations               = var.tolerations
      affinity                  = var.affinity

      initContainers = [
        {
          name    = "init-dind-externals"
          image   = "ghcr.io/actions/actions-runner:latest"
          command = ["cp", "-r", "/home/runner/externals/.", "/home/runner/tmpDir/"]
          volumeMounts = [
            {
              name      = "dind-externals",
              mountPath = "/home/runner/tmpDir"
            },
          ]
        },
        {
          name  = "dind"
          image = "docker:dind"
          args  = ["dockerd", "--host=unix:///var/run/docker.sock", "--group=$(DOCKER_GROUP_GID)"]
          env = [
            {
              name  = "DOCKER_GROUP_GID"
              value = "1001"
            },
          ]
          securityContext = {
            privileged = true
          }
          restartPolicy = "Always"
          startupProbe = {
            exec = {
              command = ["docker", "info"]
            }
            initialDelaySeconds = 0
            failureThreshold    = 24
            periodSeconds       = 5
          }
          volumeMounts = [
            {
              name      = "work"
              mountPath = "/home/runner/_work"
            },
            {
              name      = "dind-sock"
              mountPath = "/var/run"
            },
            {
              name      = "dind-externals"
              mountPath = "/home/runner/externals"
            },
          ]
        }
      ]

      containers = [
        {
          name    = "runner"
          image   = "ghcr.io/actions/actions-runner:latest"
          command = ["/home/runner/run.sh"]
          env = [
            {
              name  = "DOCKER_HOST"
              value = "unix:///var/run/docker.sock"
            },
            {
              name  = "RUNNER_WAIT_FOR_DOCKER_IN_SECONDS"
              value = "120"
            },
          ]
          volumeMounts = [
            {
              name      = "work"
              mountPath = "/home/runner/_work"
            },
            {
              name      = "dind-sock"
              mountPath = "/var/run"
              readOnly  = true
            },
          ]
        }
      ]

      volumes = [
        {
          name     = "work"
          emptyDir = {}
        },
        {
          name     = "dind-sock"
          emptyDir = {}
        },
        {
          name     = "dind-externals"
          emptyDir = {}
        },
      ]
    }
  }
}
