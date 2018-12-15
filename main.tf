# don't want remote state, would have to configure cloudshell w/ aws cli, don't wanna
# terraform {
#   backend "s3" {
#     bucket  = "terraforming-iam"
#     key     = "gke"
#     region  = "us-east-1"
#     profile = "default"
#   }
# }
module "networking" {
  source = "./modules/networking"
}
