locals {
  metadata = merge({
    "vault-token" : var.vault-token,
    "user-data" : var.cloud-init
  })
}
