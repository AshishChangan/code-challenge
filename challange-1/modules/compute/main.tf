resource "google_compute_instance" "webapp" {
  count         =  var.webapp_instances
  project       =  var.project_id
  name          =  var.webapp_vmname[count.index]
  machine_type  =  var.webapp_machine_type
  #zone         =   "${element(var.var_zones, count.index)}"
  zone          =  var.zone
  tags          = ["webserver"]
  boot_disk {
    initialize_params {
      image     =  "centos-7-v20180129"     
    }
  }
  access_config {
      // Ephemeral IP
  }
network_interface {
    #subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    subnetwork = var.webapp_subnetwork_name
  }
}

resource "google_compute_instance" "app" {
  count      =  var.app_instances
  project    = var.project_id
  name       =  var.app_vmname[count.index]
  machine_type  = var.app_machine_type
  #zone         =   "${element(var.var_zones, count.index)}"
  zone          =   var.zone
  tags          = ["http"]
  boot_disk {
    initialize_params {
      image     =  "centos-7-v20180129"     
    }
  }
network_interface {
    #subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    subnetwork = var.app_subnetwork_name
  }
}