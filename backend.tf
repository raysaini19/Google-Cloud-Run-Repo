terraform {
  backend "gcs" {
    bucket = "mansaini-burner"
    prefix = "service-access"
  }
}

# terraform {
#   backend "local" {}
# }

# terraform {
#   cloud {
#     organization = "raysaini19"

#     workspaces {
#       name = "eks-terraform"
#     }
#   }
# }