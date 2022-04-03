# provider "google" {
#   credentials = file("/home/impulcetto/gcp/youtube-pedroimpulcetto-ae43d5ef4b43.json")


#   project = "youtube-pedroimpulcetto"
#   region  = "us-central1"
#   zone    = "us-central1-c"
# }

# resource "google_compute_instance" "vm_instance" {
#   name         = "k3s-instance"
#   machine_type = "e2-micro"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   network_interface {
#     network = google_compute_network.vpc_network.name
#     access_config {
#     }
#   }
# }

# resource "google_compute_network" "vpc_network" {
#   project                 = "youtube-pedroimpulcetto"
#   name                    = "vpc-network"
#   auto_create_subnetworks = true
#   mtu                     = 1460
# }