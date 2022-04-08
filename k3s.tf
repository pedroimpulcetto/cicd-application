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
    ports    = ["5000"]
  }
  target_tags   = ["all"]
  source_tags   = ["default"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_instance" "k3s_master_instance" {
  name           = "k3s-master"
  machine_type   = "e2-micro"
  tags           = ["k3s-firewall", "http-server", "https-server"]
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = "debian-9-stretch-v20200805"
    }
  }

  metadata_startup_script = "sudo apt-get update"

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


  # provisioner "file" {
  #   source      = "./.k3s"
  #   destination = ".k3s"

  #   connection {
  #     type        = "ssh"
  #     user        = "root"
  #     host        = google_compute_instance.k3s_master_instance.network_interface.0.access_config.0.nat_ip
  #     private_key = file("~/.ssh/google_compute_engine")
  #   }
  # }

  provisioner "local-exec" {
    command = <<EOT
            sudo apt-get install git -y || git clone https://github.com/pedroimpulcetto/cicd-application.git
        EOT
  }



  provisioner "local-exec" {
    command = <<EOT
            sudo kubectl apply -f ~/cicd-application/.k3s/deployment.yaml || sudo kubectl apply -f ~/cicd-application/.k3s/services.yaml || sudo kubectl apply -f ~/cicd-application/.k3s/ingress.yaml
        EOT
  }


  depends_on = [
    google_compute_firewall.k3s-firewall,
  ]
}
