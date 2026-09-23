data "yandex_compute_image" "debian_image" {
  family = "debian-12"
}

resource "yandex_compute_instance" "debian_vm_instance" {
  name        = "debian_vm_instance"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian_image.id
      size     = 5
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    security_group_ids = [yandex_vpc_security_group.simple_server_sg.id]
    nat                = true
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      ssh_public_key = local.ssh_public_key
      user_name      = local.user_name
    })
  }

  labels = {
    project = "mentoring"
    env     = "lab"
  }
}