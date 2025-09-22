module "action_runner_scale_set_controller" {

  source        = "./modules/gha-runner-scale-set-controller"
  chart_version = var.action_runner_scale_set_controller_chart_version

  release_name = var.controller_helm_release_name

  controller_node_selector               = var.controller_node_selector
  controller_tolerations                 = var.controller_tolerations
  controller_affinity                    = var.controller_affinity
  controller_topology_spread_constraints = var.controller_topology_spread_constraints
}

module "action_runner_scale_set" {

  source        = "./modules/gha-runner-scale-set"
  chart_version = var.action_runner_scale_set_chart_version
  release_name  = var.scale_set_release_name

  github_config_url = var.github_config_url

  github_token               = var.github_token
  github_app_id              = var.github_app_id
  github_app_installation_id = var.github_app_installation_id
  github_app_private_key     = var.github_app_private_key

  runner_group          = var.runner_group
  runner_scale_set_name = var.runner_scale_set_name

  auth_method = var.auth_method

  depends_on = [module.action_runner_scale_set_controller]

  min_runners = var.min_runners
  max_runners = var.max_runners

  node_selector               = var.runner_node_selector
  tolerations                 = var.runner_tolerations
  topology_spread_constraints = var.runner_topology_spread_constraints
  affinity                    = var.runner_affinity

  template_spec_config_type     = var.runner_template_spec_config_type
  template_spec_metadata_labels = var.runner_template_spec_metadata_labels
}
