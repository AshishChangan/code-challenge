resource "google_sql_database_instance" "master" {
    name = var.database_instance_name
    database_version = var.database_instance_version
    region = var.region
    settings {
        tier = var.database_tier
        ip_configuration {
            authorized_networks = var.authorized_networks
        }
    }
}
resource "google_sql_database" "database" {
    name = var.database_name
    instance = google_sql_database_instance.master.name
    charset = "utf8"
    collation = "utf8_general_ci"
}
resource "google_sql_user" "users" {
    name = var.database_name_user
    instance = google_sql_database_instance.master.name
    host = "%"
    password = var.database_name_password
}