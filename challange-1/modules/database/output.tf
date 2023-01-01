output "instance_name" {
  value       = google_sql_database_instance.master.name
  description = "The instance name for the master instance"
}

output "instance_ip_address" {
  value       = google_sql_database_instance.master.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "private_address" {
  value       = google_sql_database_instance.master.private_ip_address
  description = "The private IP address assigned for the master instance"
}

output "instance_connection_name" {
  value       = google_sql_database_instance.master.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}
