# resource "google_pubsub_topic" "topic" {
#   name    = "job-topic"
#   project = var.project_id
# }

# resource "google_cloud_scheduler_job" "job" {
#   name        = "cloud-run-job"
#   description = "cloud run job"
#   schedule    = "*/30 * * * *"
#   project     = var.project_id
#   region = var.region

#   pubsub_target {
#     # topic.id is the topic's full resource name.
#     topic_name = google_pubsub_topic.topic.id
#     data       = base64encode("test")
#   }
# }



data "google_compute_default_service_account" "default" {
  project = var.project_id
}

resource "google_cloud_scheduler_job" "job" {
  name             = "cloud-run-job"
  description      = "cloud run job"
  schedule         = "*/1 * * * *"
  project          = var.project_id
  region           = var.region
  time_zone        = "Etc/UTC"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = google_cloud_run_v2_service.cloud_run_service.uri
    # oauth_token {
    #   service_account_email = data.google_compute_default_service_account.default.email
    # }
  }
}