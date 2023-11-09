provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials_file_path)
}

resource "google_compute_firewall" "allow_http_3000" {
  allow {
    ports    = ["3000"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  name          = "allow-http-3000"
  network       = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/networks/default"
  priority      = 1000
  project       = var.project
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http-3000"]
}

resource "google_compute_instance" "terraform_vm" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["allow-http-3000", "default-allow-ssh"]

  metadata_startup_script = "mkdir -p /home/hyperledger/tmp/;sudo mount -t tmpfs -o size=100M tmpfs /home/hyperledger/tmp/"


  metadata = {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }

  connection {
    type        = "ssh"
    user        = var.user
    host        = google_compute_instance.terraform_vm.network_interface.0.access_config.0.nat_ip
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      private_key = file(var.private_key_path)
      user        = var.user
      host        = google_compute_instance.terraform_vm.network_interface.0.access_config.0.nat_ip
      script_path = "/home/hyperledger/tmp/provision.sh"
    }

    inline = [
      "sudo chown -R hyperledger:hyperledger /home/hyperledger",
      "/home/hyperledger/tmp/provision.sh",
    ]
  }
}
