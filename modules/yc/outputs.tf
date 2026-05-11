output "hostname" {
  description = "Hostname for the YC compute instance or container name for serverless. Empty string if nothing was created."
  value = (
    var.yc_vm_create ?
    try([for s in yandex_compute_instance.this : s.hostname][0], "") :
    var.yc_serverless_create ?
    try([for s in yandex_serverless_container.this : s.name][0], "") :
    ""
  )
}

output "public_ip" {
  description = "NAT IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created."
  value = (
    var.yc_vm_create ?
    try([for s in yandex_compute_instance.this : s.network_interface[0].nat_ip_address][0], "") :
    var.yc_serverless_create ? "serverless" : ""
  )
}

output "private_ip" {
  description = "Private IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created."
  value = (
    var.yc_vm_create ?
    try([for s in yandex_compute_instance.this : s.network_interface[0].ip_address][0], "") :
    var.yc_serverless_create ? "serverless" : ""
  )
}

output "id" {
  description = "ID of the created YC resource (compute instance ID or serverless container ID)."
  value = (
    var.yc_vm_create ?
    try([for s in yandex_compute_instance.this : s.id][0], "") :
    var.yc_serverless_create ?
    try([for s in yandex_serverless_container.this : s.id][0], "") :
    ""
  )
}
