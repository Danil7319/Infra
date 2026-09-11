provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  storage_endpoint         = "storage.yandexcloud.net"
  zone                     = "ru-central1-b"
}
