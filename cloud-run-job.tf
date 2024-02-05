resource "google_cloud_run_v2_job" "cloud_run_job_teraform" {
  name     = var.cloud_run_job
  location = var.region
  project  = var.project_id

  template {
    template {
      volumes {
        name = "volume-job"
        secret {
          secret       = google_secret_manager_secret.job_secret.secret_id
          default_mode = 292 # 0444
          items {
            version = "1"
            path    = "secret"
            mode    = 256 # 0400
          }
        }
      }
      containers {
        image = var.cloud_run_job_image
        volume_mounts {
          name       = "volume-job"
          mount_path = "/secrets"
        }
        resources {
          limits = {
            cpu    = "2"
            memory = "1024Mi"
          }
        }
      }
      vpc_access {
        connector = google_vpc_access_connector.cloud_run_connector.id
        egress    = "ALL_TRAFFIC"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
  depends_on = [
    google_secret_manager_secret_version.job_secret_version_data,
    google_secret_manager_secret_iam_member.job_secret_access,
  ]
}

#### Creates a secret in Google Cloud Secret Manager.
resource "google_secret_manager_secret" "job_secret" {
  secret_id = "secret-job"
  labels = {
    label = "cloud-run-job"
  }
  project = var.project_id
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
#### Creates a specific version of a secret's data.
resource "google_secret_manager_secret_version" "job_secret_version_data" {
  secret      = google_secret_manager_secret.job_secret.name
  secret_data = "secret-job"
}
resource "google_secret_manager_secret_iam_member" "job_secret_access" {
  secret_id  = google_secret_manager_secret.job_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:99823646674-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.job_secret]
}





# #### Output
# output "cloud_run_job_uri" {
#   value = google_cloud_run_v2_job.cloud_run_job_teraform.uri
# }