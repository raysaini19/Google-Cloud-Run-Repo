# #### Cloud SQL database instance
# resource "google_sql_database_instance" "instance" {
#   name             = var.sql_name
#   region           = var.region
#   database_version = var.sql_database_version
#   project          = var.project_id
#   settings {
#     tier = var.sql_tier
#   }
#   deletion_protection = var.sql_deletion_protection
# }