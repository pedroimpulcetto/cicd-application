provider "google" {
  credentials = file("/home/impulcetto/gcp/youtube-pedroimpulcetto-ae43d5ef4b43.json")


  project = "youtube-pedroimpulcetto"
  region  = "us-central1"
  zone    = "us-central1-c"
}


resource "google_compute_firewall" "k3s-firewall" {
  name    = "k3s-firewall"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  target_tags = ["k3s"]
  source_tags = ["vpc-network"]
}


resource "google_compute_instance" "k3s_master_instance" {
  name         = "k3s-master"
  machine_type = "e2-micro"
  tags         = ["k3s", "k3s-master"]

  boot_disk {
    initialize_params {
      image = "debian-9-stretch-v20200805"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  provisioner "local-exec" {
    command = <<EOT
            k3sup install \
            --ip ${self.network_interface[0].access_config[0].nat_ip} \
            --context k3s \
            --ssh-key ~/.ssh/google_compute_engine \
            --user $(whoami)
        EOT
  }

  depends_on = [
    google_compute_firewall.k3s-firewall,
  ]
}

resource "google_compute_network" "vpc_network" {
  project                 = "youtube-pedroimpulcetto"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}
