resource "yandex_vpc_network" "terraform-network" {
  name = "terraform-network"
  labels = {
    tf-label    = "terraform-network"
    empty-label = ""
  }
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet_a"
  description    = "Sandbox Subnet A"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["10.0.1.0/24"]

  labels = {
    environment = "sandbox"
  }
}
locals {
  ingress_rules = {
    ssh = {
      description = "SSH"
      port        = 22
    }
    http = {
      description = "HTTP"
      port        = 80
    }
    https = {
      description = "HTTPS"
      port        = 443
    }
    prometheus = {
      description = "Prometheus"
      port        = 9090
    }
    grafana = {
      description = "Grafana"
      port        = 3000
    }
    node_exporter = {
      description = "Node_Exporter"
      port        = 9100
    }
  }
}
resource "yandex_vpc_security_group" "simple_server_sg" {
  name        = "server-sg"
  description = "Security group"
  network_id  = yandex_vpc_network.terraform-network.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      protocol       = "TCP"
      description    = ingress.value.description
      v4_cidr_blocks = [local.my_ip]
      port           = ingress.value.port
    }
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}