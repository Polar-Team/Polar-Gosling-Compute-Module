data "yandex_client_config" "client" {
  count = (var.yc_vm_create || var.yc_serverless_create) ? 1 : 0
}

data "yandex_compute_image" "image" {
  count = var.yc_vm_create ? 1 : 0

  image_id = var.source_image_id
  family   = var.source_image_family
}
