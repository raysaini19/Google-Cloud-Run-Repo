
#### To create Google Cloud Run Service
resource "google_cloud_run_v2_service" "cloud_run_service" {
  name     = var.cloud_run_service
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  project  = var.project_id

  template {
    volumes {
      name = "volume-service"
      secret {
        secret       = google_secret_manager_secret.service_secret.secret_id
        default_mode = 292 # 0444
        items {
          version = "1"
          path    = "secret-service"
          mode    = "0444"
        }
      }
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts {
        name       = "volume-service"
        mount_path = "/secrets"
      }
    }
    scaling {
      max_instance_count = 2
    }
    vpc_access {
      connector = google_vpc_access_connector.cloud_run_connector.id
      egress    = "ALL_TRAFFIC"
    }
  }
  depends_on = [
    google_secret_manager_secret_version.service_secret_version_data,
    google_secret_manager_secret_iam_member.service_secret_access,
  ]
}



#### To access the Cloud Run service publicly, allow unauthenticated invocations. By adding an IAM policy binding for allUsers with the role roles/run.invoker1.
data "google_iam_policy" "allUsers" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "allUsers" {
  location    = google_cloud_run_v2_service.cloud_run_service.location
  project     = google_cloud_run_v2_service.cloud_run_service.project
  service     = google_cloud_run_v2_service.cloud_run_service.name
  policy_data = data.google_iam_policy.allUsers.policy_data
}



#### Creates a secret in Google Cloud Secret Manager.
resource "google_secret_manager_secret" "service_secret" {
  secret_id = "secret-service"
  labels = {
    label = "cloud-run-service"
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
resource "google_secret_manager_secret_version" "service_secret_version_data" {
  secret      = google_secret_manager_secret.service_secret.name
  secret_data = "secret-service"
}

#### Grants IAM permissions to a member for a secret in Google Cloud Secret Manager
resource "google_secret_manager_secret_iam_member" "service_secret_access" {
  secret_id  = google_secret_manager_secret.service_secret.id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:99823646674-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.service_secret]
}



#### Output
output "cloud_run_service_uri" {
  value = google_cloud_run_v2_service.cloud_run_service.uri
}
