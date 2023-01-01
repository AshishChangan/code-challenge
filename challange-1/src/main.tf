/* module "vpc" {
    source  = "terraform-google-modules/network/google//modules/vpc"
    project_id   = "<PROJECT ID>"
    network_name = "example-vpc"
    shared_vpc_host = false
} */

module "vpc" {
    source  = "../modules/vpc"
    auto_create_subnetworks = "false"
    project_id   = var.project_id
    network_name = var.network_name
    shared_vpc_host = false
    subnets = [
        {
            subnet_name           = "Public-Subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
            subnet_flow_logs      = "true"
        },
        {
            subnet_name           = "Private-Subnet-01"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
        }
    ]
}

module "firewall_rules" {
  source       = "../modules/vpc"
  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [{
    name                    = "webserver-ingress-rules"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    target_tags             = var.webapp_tags
    target_service_accounts = null
    allow = [{
      protocol = ["tcp","http","https"]
      ports    = ["22","80","443"]
    }]
    deny = []
  },{
    name                    = "webserver-egress-rules"
    description             = null
    direction               = "EGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    target_tags             = var.webapp_tags
    target_service_accounts = null
    allow = []
    deny = []
  },{
    name                    = "app-INGRESS-rules"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = null
    source_tags             = var.webapp_tags
    target_tags             = var.app_tags
    target_service_accounts = null
    allow = [{
      protocol = ["http"]
      ports    = ["80"]
    }]
    deny = []
  },{
    name                    = "db-INGRESS-rules"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = null
    source_tags             = var.app_tags
    target_tags             = var.database_tags
    target_service_accounts = null
    allow = [{
      protocol = ["tcp"]
      ports    = ["3306"]
    }]
    deny = []
  }]
}

module "webapp_instance_template" {
  source          = "../modules/instancetemplates"
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  tags            = var.webapp_tags
  name            ="webserver-template"
}

module "app_instance_template" {
  source          = "../modules/instancetemplates"
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  tags            = var.app_tags
  name            ="appserver-template"
}

module "mig" {
  source              = "../modules/autoscaling"
  project_id          = var.project_id
  region              = var.region
  hostname            = "mig-autoscaler"
  autoscaling_enabled = var.autoscaling_enabled
  min_replicas        = var.min_replicas
  max_replicas        = var.max_replicas
  autoscaling_cpu     = var.autoscaling_cpu
  instance_template   = var.template_name
}

module "database_instance" {
  source = "../modules/database"
  name = var.database_instance_name
  database_version = var.database_instance_version
  region = var.region
  authorized_networks = var.authorized_networks
  tier = var.database_tier

}

module "database" {
  source = "../modules/database"
  name = var.database_name
  instance = google_sql_database_instance.master.name
  db_usr = var.database_name_user
  password = var.database_name_password
  tags = var.database_tags
}

module "loadbalancer"{
  source = "../modules/lb"
  name                = "backend-lb"
  project             = var.project
  enable_ipv6         = true
  create_ipv6_address = true
  http_forward        = false
  load_balancing_scheme = var.load_balancing_scheme

}