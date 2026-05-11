locals {
  labels = merge({
    created_at = formatdate("DD-MM-YYYY-hh-mm", timestamp()),
    owner      = var.owner
    group      = var.group
    },
  var.additional_labels)
}
