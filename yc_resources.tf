resource "yandex_compute_instance" "this" {

  count = var.yc_create ? 1 : 0

  platform_id               = var.vm_vcpu_type
  name                      = "${var.yc_prefix}${var.yc_postfix}"
  description               = var.description
  hostname                  = "${var.yc_prefix}${var.yc_postfix}.${var.domain_name}"
  allow_stopping_for_update = var.allow_stopping_for_update
  network_acceleration_type = var.network_acceleration_type
  service_account_id        = var.service_account_id
  labels                    = local.labels
  zone                      = var.creation_zone


  dynamic "placement_policy" {
    for_each = length(var.placement_policy) > 0 ? var.placement_policy : []
    content {
      placement_group_id = try(placement_policy.value.placement_group_id, null)
      dynamic "host_affinity_rules" {
        for_each = try([placement_policy.value.host_affinity_rules], [])
        content {
          key    = host_affinity_rules.value.key
          op     = host_affinity_rules.value.op
          values = lookup(host_affinity_rules.value, "values", null)
        }
      }
    }
  }


  lifecycle {
    ignore_changes = [
      name,
      labels
    ]
    create_before_destroy = false
  }

  timeouts {
    create = var.timeout
    update = var.timeout
    delete = var.timeout
  }

  dynamic "scheduling_policy" {
    for_each = try([var.scheduling_policy], [])
    content {
      preemptible = try(scheduling_policy.value.preemptible, false)
    }
  }

  resources {
    gpus          = 0
    cores         = var.vm_vcpu_qty
    core_fraction = var.core_fraction
    memory        = var.vm_ram_qty
  }

  boot_disk {
    auto_delete = try(var.boot_disk.auto_delete, true)
    device_name = try(var.boot_disk.device_name, null)
    mode        = try(var.boot_disk.mode, "READ_WRITE")
    disk_id     = try(var.boot_disk.disk_id, null)

    initialize_params {
      image_id    = data.yandex_compute_image.image.id
      size        = try(var.boot_disk.initialize_params.size, null)
      type        = try(var.boot_disk.initialize_params.type, null)
      name        = try(var.boot_disk.initialize_params.name, null)
      description = try(var.boot_disk.initialize_params.description, null)
      snapshot_id = try(var.boot_disk.initialize_params.snapshot_id, null)
      block_size  = try(var.boot_disk.initialize_params.block_size, null)

    }
  }


  dynamic "secondary_disk" {
    for_each = length(var.secondary_disk) > 0 ? var.secondary_disk : []
    content {
      disk_id     = secondary_disk.value.disk_id
      auto_delete = try(secondary_disk.value.auto_delete, false)
      device_name = try(secondary_disk.value.device_name, null)
      mode        = try(secondary_disk.value.mode, "READ_WRITE")
    }
  }


  dynamic "local_disk" {
    for_each = length(var.local_disk) > 0 ? var.local_disk : []
    content {
      size_bytes = try(local_disk.value.size_bytes, 16000000000)
    }
  }

  dynamic "filesystem" {
    for_each = length(var.filesystem) > 0 ? var.filesystem : []
    content {
      filesystem_id = filesystem.value.filesystem_id
      device_name   = try(filesystem.value.device_name, null)
      mode          = try(filesystem.value.mode, "READ_WRITE")
    }
  }

  dynamic "metadata_options" {
    for_each = length(var.yc_metadata_options) > 0 ? [var.yc_metadata_options] : []
    content {
      aws_v1_http_endpoint = lookup(var.metadata_options, "aws_v1_http_endpoint", 1)
      aws_v1_http_token    = lookup(var.metadata_options, "aws_v1_http_token", 2)
      gce_http_endpoint    = lookup(var.metadata_options, "gce_http_endpoint", 1)
      gce_http_token       = lookup(var.metadata_options, "gce_http_token", 1)
    }
  }



  metadata = {
    "user-data" : var.cloud-init
  }


  dynamic "network_interface" {
    for_each = var.yc_network_interface
    content {
      subnet_id          = network_interface.value.subnet_id
      security_group_ids = try(network_interface.value.security_group_ids, [])
      nat                = try(network_interface.value.nat, false)
      nat_ip_address     = try(network_interface.value.nat_ip_address, null)
      ipv4               = try(network_interface.value.ipv4, true)
      ip_address         = try(network_interface.value.ip_address, null)
      ipv6               = try(network_interface.value.ipv6, null)
      ipv6_address       = try(network_interface.value.ipv6_address, null)
      dynamic "dns_record" {
        for_each = try([network_interface.value.dns_record], [])
        content {
          fqdn        = try(dns_record.value.fqdn, null)
          dns_zone_id = try(dns_record.value.dns_zone_id, null)
          ttl         = try(dns_record.ttl, null)
          ptr         = try(dns_record.ptr, null)
        }
      }
      dynamic "ipv6_dns_record" {
        for_each = try([network_interface.value.ipv6_dns_record], [])
        content {
          fqdn        = try(ipv6_dns_record.value.fqdn, null)
          dns_zone_id = try(ipv6_dns_record.value.dns_zone_id, null)
          ttl         = try(ipv6_dns_record.ttl, null)
          ptr         = try(ipv6_dns_record.ptr, null)
        }
      }
      dynamic "nat_dns_record" {
        for_each = try([network_interface.value.at_dns_record], [])
        content {
          fqdn        = try(nat_dns_record.value.fqdn, null)
          dns_zone_id = try(nat_dns_record.value.dns_zone_id, null)
          ttl         = try(nat_dns_record.ttl, null)
          ptr         = try(nat_dns_record.ptr, null)
        }
      }
    }
  }

}
