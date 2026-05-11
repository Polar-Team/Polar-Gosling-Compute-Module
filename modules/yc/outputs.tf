output "hostname" {
  description = "Hostname for the YC compute instance or container name for serverless. Empty string if nothing was created."
  value = (
    var.yc_vm_create ? yandex_compute_instance.this[0].hostname :
    var.yc_serverless_create ? yandex_serverless_container.this[0].name :
    ""
  )
}

output "public_ip" {
  description = "NAT IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created."
  value = (
    var.yc_vm_create ? yandex_compute_instance.this[0].network_interface[0].nat_ip_address :
    var.yc_serverless_create ? "serverless" :
    ""
  )
}

output "private_ip" {
  description = "Private IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created."
  value = (
    var.yc_vm_create ? yandex_compute_instance.this[0].network_interface[0].ip_address :
    var.yc_serverless_create ? "serverless" :
    ""
  )
}

output "id" {
  description = "ID of the created YC resource (compute instance ID or serverless container ID)."
  value = (
    var.yc_vm_create ? yandex_compute_instance.this[0].id :
    var.yc_serverless_create ? yandex_serverless_container.this[0].id :
    ""
  )
}
