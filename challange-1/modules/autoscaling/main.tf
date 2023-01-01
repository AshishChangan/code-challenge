
module "mig_template" {
  source ="../instancetemplates"
}

resource "google_compute_region_instance_group_manager" "mig" {
  provider           = google
  base_instance_name = var.hostname
  project            = var.project_id

  version {
    name              = "${var.hostname}-mig-version-0"
    instance_template = module.mig_template.name
  }

  name   = var.mig_name == "" ? "${var.hostname}-mig" : var.mig_name
  region = var.region
  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = lookup(named_port.value, "name", null)
      port = lookup(named_port.value, "port", null)
    }
  }
  target_pools = var.target_pools
  target_size  = var.autoscaling_enabled ? null : var.target_size

  wait_for_instances = var.wait_for_instances

  timeouts {
    create = var.mig_timeouts.create
    update = var.mig_timeouts.update
    delete = var.mig_timeouts.delete
  }
}

resource "google_compute_region_autoscaler" "autoscaler" {
  provider = google
  count    = var.autoscaling_enabled ? 1 : 0
  name     = var.autoscaler_name == "" ? "${var.hostname}-autoscaler" : var.autoscaler_name
  project  = var.project_id
  region   = var.region

  target = google_compute_region_instance_group_manager.mig.self_link

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period
    mode            = var.autoscaling_mode
    dynamic "cpu_utilization" {
      for_each = var.autoscaling_cpu
      content {
        target            = lookup(cpu_utilization.value, "target", null)
        predictive_method = lookup(cpu_utilization.value, "predictive_method", null)
      }
    }
  }
}
