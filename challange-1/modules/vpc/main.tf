resource "google_compute_network" "network" {
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  project                         = var.project_id
  description                     = var.description
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu                             = var.mtu
}

locals {
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}


/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = local.subnets
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
  network     = var.network_name
  project     = var.project_id
  description = lookup(each.value, "description", null)
  purpose = lookup(each.value, "purpose", null)
}

/******************************************
	Firewall configuration
 *****************************************/

resource "google_compute_firewall" "rules" {
  for_each                = { for r in var.rules : r.name => r }
  name                    = each.value.name
  description             = each.value.description
  direction               = each.value.direction
  network                 = var.network_name
  project                 = var.project_id
  source_ranges           = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges      = each.value.direction == "EGRESS" ? each.value.ranges : null
  source_tags             = each.value.source_tags
  source_service_accounts = each.value.source_service_accounts
  target_tags             = each.value.target_tags
  target_service_accounts = each.value.target_service_accounts
  priority                = each.value.priority

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      #protocol = allow.value.protocol
      protocol = lookup(allow.value, "protocol", null)
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      #protocol = deny.value.protocol
      protocol = lookup(deny.value, "protocol", null)
      ports    = lookup(deny.value, "ports", null)
    }
  }
}