#### Generic Variables
variable "project_id" {
  default = "burner-mansaini"
}
variable "region" {
  default = "us-central1"
}




#### Cloud Run job 
variable "cloud_run_job" {
  description = "Name must be unique within a Google Cloud project and region"
  type        = string
}
variable "cloud_run_job_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}
variable "cloud_run_job_accout_email" {
  type    = string
  default = "99823646674-compute@developer.gserviceaccount.com"
}


#### Cloud Run Service
variable "cloud_run_service" {
  description = "Name must be unique within a Google Cloud project and region"
  type        = string
}
variable "cloud_run_service_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}
variable "cloud_run_service_accout_email" {
  type    = string
  default = "99823646674-compute@developer.gserviceaccount.com"
}

# #### SQL Instance 
# variable "sql_name" {
#   description = "The name of the instance, If the name is left blank, Terraform will randomly generate one when the instance is first created"
#   type        = string
#   default     = "cloudrun-sql"
# }
# variable "sql_database_version" {
#   description = "PostgreSQL or SQL Server version to use"
#   type        = string
#   default     = "MYSQL_8_0"
# }
# variable "sql_tier" {
#   description = "The machine type to usel"
#   type        = string
#   default     = "db-f1-micro"
# }
# variable "sql_deletion_protection" {
#   description = "Whether or not to allow Terraform to destroy the instance"
#   type        = bool
#   default     = "false"
# }



