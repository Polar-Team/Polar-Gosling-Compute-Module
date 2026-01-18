resource "random_string" "aws-this" {

  length  = 12
  special = false
  lower   = true
  upper   = false

}

#################################################
#                                               #
#         AWS VM provider resources             #
#                                               #
#################################################

resource "aws_instance" "this" {
  count = var.aws_vm_create ? 1 : 0

  ami           = local.ami
  instance_type = var.instance_type
  hibernation   = var.hibernation

  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change

  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name             = var.key_name
  monitoring           = var.monitoring
  get_password_data    = var.get_password_data
  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  dynamic "cpu_options" {
    for_each = length(var.cpu_options) > 0 ? [var.cpu_options] : []

    content {
      core_count       = try(cpu_options.value.core_count, null)
      threads_per_core = try(cpu_options.value.threads_per_core, null)
      amd_sev_snp      = try(cpu_options.value.amd_sev_snp, null)
    }
  }

  dynamic "capacity_reservation_specification" {
    for_each = length(var.capacity_reservation_specification) > 0 ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = try(capacity_reservation_specification.value.capacity_reservation_preference, null)

      dynamic "capacity_reservation_target" {
        for_each = try([capacity_reservation_specification.value.capacity_reservation_target], [])

        content {
          capacity_reservation_id                 = try(capacity_reservation_target.value.capacity_reservation_id, null)
          capacity_reservation_resource_group_arn = try(capacity_reservation_target.value.capacity_reservation_resource_group_arn, null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device

    content {
      delete_on_termination = try(root_block_device.value.delete_on_termination, null)
      encrypted             = try(root_block_device.value.encrypted, null)
      iops                  = try(root_block_device.value.iops, null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = try(root_block_device.value.volume_size, null)
      volume_type           = try(root_block_device.value.volume_type, null)
      throughput            = try(root_block_device.value.throughput, null)
      tags                  = try(root_block_device.value.tags, null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device

    content {
      delete_on_termination = try(ebs_block_device.value.delete_on_termination, null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = try(ebs_block_device.value.encrypted, null)
      iops                  = try(ebs_block_device.value.iops, null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = try(ebs_block_device.value.volume_size, null)
      volume_type           = try(ebs_block_device.value.volume_type, null)
      throughput            = try(ebs_block_device.value.throughput, null)
      tags                  = try(ebs_block_device.value.tags, null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device

    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = try(ephemeral_block_device.value.no_device, null)
      virtual_name = try(ephemeral_block_device.value.virtual_name, null)
    }
  }

  dynamic "metadata_options" {
    for_each = length(var.aws_metadata_options) > 0 ? [var.aws_metadata_options] : []

    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, "enabled")
      http_tokens                 = "required"
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, 1)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }

  dynamic "network_interface" {
    for_each = var.aws_network_interface

    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = try(network_interface.value.delete_on_termination, false)
    }
  }

  dynamic "private_dns_name_options" {
    for_each = length(var.private_dns_name_options) > 0 ? [var.private_dns_name_options] : []

    content {
      hostname_type                        = try(private_dns_name_options.value.hostname_type, null)
      enable_resource_name_dns_a_record    = try(private_dns_name_options.value.enable_resource_name_dns_a_record, null)
      enable_resource_name_dns_aaaa_record = try(private_dns_name_options.value.enable_resource_name_dns_aaaa_record, null)
    }
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) > 0 ? [var.launch_template] : []

    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  dynamic "maintenance_options" {
    for_each = length(var.maintenance_options) > 0 ? [var.maintenance_options] : []

    content {
      auto_recovery = try(maintenance_options.value.auto_recovery, null)
    }
  }

  enclave_options {
    enabled = var.enclave_options_enabled
  }

  source_dest_check                    = length(var.aws_network_interface) > 0 ? null : var.source_dest_check
  disable_api_termination              = var.disable_api_termination
  disable_api_stop                     = var.disable_api_stop
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = var.placement_group
  tenancy                              = var.tenancy
  host_id                              = var.host_id

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags        = merge({ "Name" = "${var.aws_prefix}-${random_string.aws-this.result}" }, var.instance_tags, var.tags, local.labels)
  volume_tags = var.enable_volume_tags ? merge({ "Name" = "${var.aws_prefix}-${random_string.aws-this.result}" }, var.volume_tags) : null
}

#################################################
#                                               #
#         AWS ECS container resources           #
#                                               #
#################################################

resource "aws_ecs_cluster" "this" {
  count = var.aws_ecs_create ? 1 : 0


  dynamic "setting" {
    for_each = flatten([try(var.ecs_settings, [])])
    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }

  dynamic "configuration" {
    for_each = flatten([try(var.ecs_configurations, [])])
    content {
      dynamic "execute_command_configuration" {
        for_each = flatten([try(configuration.value.execute_command_configuration, [])])
        content {
          logging    = try(execute_command_configuration.value.logging, null)
          kms_key_id = try(execute_command_configuration.value.kms_key_id, null)
          dynamic "log_configuration" {
            for_each = flatten([try(execute_command_configuration.value.log_configuration, [])])
            content {
              cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)
              cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
              s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
              s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
              s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
            }
          }
        }
      }
      dynamic "managed_storage_configuration" {
        for_each = flatten([try(configuration.value.managed_storage_configuration, [])])
        content {
          fargate_ephemeral_storage_kms_key_id = try(managed_storage_configuration.value.fargate_ephemeral_storage_kms_key_id, null)
          kms_key_id                           = try(managed_storage_configuration.value.kms_key_id, null)
        }
      }
    }
  }

  dynamic "service_connect_defaults" {
    for_each = flatten([try(var.ecs_service_connect_defaults, [])])
    content {
      namespace = service_connect_defaults.value.namespace
    }
  }


  name = "${var.aws_prefix}-ecs-cluster-${random_string.aws-this.result}"
  tags = merge({ "Name" = "${var.aws_prefix}-ecs-cluster-${random_string.aws-this.result}" }, var.ecs_tags, var.tags, local.labels)
}

resource "aws_ecs_task_definition" "this" {
  count = var.aws_ecs_create ? 1 : 0

  family       = "${var.aws_prefix}-ecs-task-${random_string.aws-this.result}"
  network_mode = var.ecs_network_mode
  ipc_mode     = var.ecs_ipc_mode
  pid_mode     = var.ecs_pid_mode

  enable_fault_injection = var.ecs_enable_fault_injection
  skip_destroy           = var.ecs_skip_destroy

  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  tags         = merge({ "Name" = "${var.aws_prefix}-ecs-task-${random_string.aws-this.result}" }, var.ecs_tags, var.tags, local.labels)
  track_latest = var.ecs_track_latest

  container_definitions = local.container_definitions_json

  requires_compatibilities = var.ecs_requires_compatibilities

  dynamic "volume" {
    for_each = flatten([try(var.ecs_volumes, [])])
    content {
      name                = volume.value.name
      host_path           = try(volume.value.host_path, null)
      configure_at_launch = try(volume.value.configure_at_launch, null)
      dynamic "docker_volume_configuration" {
        for_each = flatten([try(volume.value.docker_volume_configuration, [])])
        content {
          scope         = try(docker_volume_configuration.value.scope, null)
          autoprovision = try(docker_volume_configuration.value.autoprovision, null)
          driver        = try(docker_volume_configuration.value.driver, null)
          driver_opts   = try(docker_volume_configuration.value.driver_opts, null)
          labels        = try(docker_volume_configuration.value.labels, null)
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = flatten([try(volume.value.efs_volume_configuration, [])])
        content {
          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = try(efs_volume_configuration.value.root_directory, null)
          transit_encryption      = try(efs_volume_configuration.value.transit_encryption, null)
          transit_encryption_port = try(efs_volume_configuration.value.transit_encryption_port, null)
          dynamic "authorization_config" {
            for_each = flatten([try(efs_volume_configuration.value.authorization_config, [])])
            content {
              access_point_id = try(authorization_config.value.access_point_id, null)
              iam             = try(authorization_config.value.iam, null)
            }
          }
        }
      }
      dynamic "fsx_windows_file_server_volume_configuration" {
        for_each = flatten([try(volume.value.fsx_windows_file_server_volume_configuration, [])])
        content {
          file_system_id = fsx_windows_file_server_volume_configuration.value.file_system_id
          root_directory = try(fsx_windows_file_server_volume_configuration.value.root_directory, null)
          dynamic "authorization_config" {
            for_each = [fsx_windows_file_server_volume_configuration.value.authorization_config]
            content {
              credentials_parameter = try(authorization_config.value.credentials_parameter, null)
              domain                = try(authorization_config.value.domain, null)
            }
          }
        }
      }
    }
  }

  dynamic "runtime_platform" {
    for_each = flatten([try(var.ecs_runtime_platform, [])])
    content {
      cpu_architecture        = try(runtime_platform.value.cpu_architecture, null)
      operating_system_family = try(runtime_platform.value.operating_system_family, null)
    }
  }

  dynamic "placement_constraints" {
    for_each = flatten([try(var.ecs_placement_constraints, [])])
    content {
      type       = placement_constraints.value.type
      expression = try(placement_constraints.value.expression, null)
    }
  }

  dynamic "proxy_configuration" {
    for_each = flatten([try(var.ecs_proxy_configuration, [])])
    content {
      type           = try(proxy_configuration.value.type, null)
      container_name = proxy_configuration.value.container_name
      properties     = proxy_configuration.value.properties
    }
  }

  dynamic "ephemeral_storage" {
    for_each = flatten([try(var.ecs_ephemeral_storage, [])])
    content {
      size_in_gib = ephemeral_storage.value.size_in_gib
    }
  }


}
