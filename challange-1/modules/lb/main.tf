resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}
resource "google_compute_global_forwarding_rule" "http" {
  provider   = google-beta
  project    = var.project
  name       = "${var.name}-http-rule"
  target     = google_compute_target_http_proxy.http.id
  ip_address = google_compute_global_address.default.address
  port_range = "80"
  depends_on = [google_compute_global_address.default]
}

resource "google_compute_target_http_proxy" "http" {
  project = var.project
  name    = "${var.name}-http-proxy"
  url_map = google_compute_region_url_map.default.id
}

# URL map
resource "google_compute_region_url_map" "default" {
  name            = "l7-ilb-regional-url-map"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
  host_rule {
    hosts        = ["site.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.id
  }
}
module "mig" {
    source = "../autoscaling"
}
# backend service
resource "google_compute_region_backend_service" "default" {
  name                  = "l7-ilb-backend-subnet"
  provider              = google-beta
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = var.load_balancing_scheme
  timeout_sec           = 10
  backend {
    group           = module.mig.instance_group
  }
}