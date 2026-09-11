output "detected_my_ip" {
  description = "My Public IP (CIDR /32)"
  value       = local.my_ip
}

output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = yandex_compute_instance.debian_vm_instance.network_interface.0.nat_ip_address
}

output "ssh_command" {
  description = "Public IP of the VM"
  value       = "ssh debian@${yandex_compute_instance.debian_vm_instance.network_interface.0.nat_ip_address}"
}