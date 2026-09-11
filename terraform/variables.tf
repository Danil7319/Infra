variable "service_account_key_file" {
  description = "Path to the service account key file"
  default     = "key.json"
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Folder ID"
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to public SSH key"
  type        = string
}