data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"

  lifecycle {
    postcondition {
      condition     = can(jsondecode(self.response_body).ip)
      error_message = "Не удалось получить значение моего IP"
    }
  }
}

locals {
  my_ip          = "${jsondecode(data.http.my_ip.response_body).ip}/32"
  ssh_public_key = trimspace(file(var.ssh_public_key_path))
}


