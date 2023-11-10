provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = file(var.credentials_file_path)
}

resource "google_compute_firewall" "allow_http_3000_8080" {
  allow {
    ports    = ["3000", "8080"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  name          = "allow-http-3000-8080"
  network       = "https://www.googleapis.com/compute/v1/projects/${var.project}/global/networks/default"
  priority      = 1000
  project       = var.project
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http-3000-8080"]
}

resource "google_compute_instance" "terraform_vm" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["allow-http-3000-8080", "default-allow-ssh"]

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
    inline = [
      "sudo apt update",
      "sudo apt install -y build-essential git",

      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)\"  -o /usr/local/bin/docker-compose",
      "sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo chmod +x /usr/bin/docker-compose",


      "echo \"Cloning repo...\"",
      "git clone https://github.com/xavgar9/EmployeeManagementTerraform",
      "cd EmployeeManagementTerraform",

      "echo \"Building backend image...\"",
      "sudo docker pull xavgar9/employee-management-backend:latest",

      "echo \"Building frontend image...\"",
      "sudo docker pull xavgar9/employee-management-frontend:latest",

      "echo \"Starting containers with docker-compose...\"",
      "sudo export REACT_APP_BACKEND_HOST=http://${google_compute_instance.terraform_vm.network_interface.0.access_config.0.nat_ip}:8080",
      "sudo docker compose up -d",

      "echo \"Running migration...\"",
      "sudo -u root docker exec -i db mysql -uroot -proot -e 'CREATE DATABASE IF NOT EXISTS employeemanagement;'",
      "sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./scripts/CreateDB.sql",
      "sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./scripts/FunctionsProcedures.sql",
      "sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./scripts/ResetDB.sql",
    ]
  }
}
