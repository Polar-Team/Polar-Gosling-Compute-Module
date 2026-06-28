##################################################
#                                                #
#   Per-cloud delegation                         #
#                                                #
#   The AWS and Yandex resources live in two     #
#   dedicated submodules. Each submodule only    #
#   declares the providers it actually needs.    #
#                                                #
#   When a user enables only YC resources the    #
#   AWS submodule is instantiated with count=0,  #
#   so the AWS provider is never configured and  #
#   the caller does not need to declare a        #
#   `provider "aws" {}` block (and vice versa).  #
#                                                #
##################################################

module "aws" {
  source = "./modules/aws"
  count  = (var.aws_vm_create || var.aws_ecs_create) ? 1 : 0

  labels = local.labels

  # Creation toggles + prefix
  aws_vm_create  = var.aws_vm_create
  aws_ecs_create = var.aws_ecs_create
  aws_prefix     = var.aws_prefix

  # EC2 instance inputs
  ami                                  = var.ami
  ami_ssm_parameter                    = var.ami_ssm_parameter
  associate_public_ip_address          = var.associate_public_ip_address
  availability_zone                    = var.availability_zone
  aws_metadata_options                 = var.aws_metadata_options
  aws_network_interface                = var.aws_network_interface
  capacity_reservation_specification   = var.capacity_reservation_specification
  cpu_credits                          = var.cpu_credits
  cpu_options                          = var.cpu_options
  disable_api_stop                     = var.disable_api_stop
  disable_api_termination              = var.disable_api_termination
  ebs_block_device                     = var.ebs_block_device
  ebs_optimized                        = var.ebs_optimized
  enable_volume_tags                   = var.enable_volume_tags
  enclave_options_enabled              = var.enclave_options_enabled
  ephemeral_block_device               = var.ephemeral_block_device
  get_password_data                    = var.get_password_data
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_tags                        = var.instance_tags
  instance_type                        = var.instance_type
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = var.key_name
  launch_template                      = var.launch_template
  maintenance_options                  = var.maintenance_options
  monitoring                           = var.monitoring
  placement_group                      = var.placement_group
  private_dns_name_options             = var.private_dns_name_options
  private_ip                           = var.private_ip
  root_block_device                    = var.root_block_device
  secondary_private_ips                = var.secondary_private_ips
  source_dest_check                    = var.source_dest_check
  subnet_id                            = var.subnet_id
  tags                                 = var.tags
  tenancy                              = var.tenancy
  timeouts                             = var.timeouts
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  user_data_replace_on_change          = var.user_data_replace_on_change
  volume_tags                          = var.volume_tags
  vpc_security_group_ids               = var.vpc_security_group_ids

  # ECS cluster + task inputs
  ecs_configurations           = var.ecs_configurations
  ecs_cpu                      = var.ecs_cpu
  ecs_enable_fault_injection   = var.ecs_enable_fault_injection
  ecs_ephemeral_storage        = var.ecs_ephemeral_storage
  ecs_execution_role_arn       = var.ecs_execution_role_arn
  ecs_ipc_mode                 = var.ecs_ipc_mode
  ecs_memory                   = var.ecs_memory
  ecs_network_mode             = var.ecs_network_mode
  ecs_pid_mode                 = var.ecs_pid_mode
  ecs_placement_constraints    = var.ecs_placement_constraints
  ecs_proxy_configuration      = var.ecs_proxy_configuration
  ecs_requires_compatibilities = var.ecs_requires_compatibilities
  ecs_runtime_platform         = var.ecs_runtime_platform
  ecs_service_connect_defaults = var.ecs_service_connect_defaults
  ecs_settings                 = var.ecs_settings
  ecs_skip_destroy             = var.ecs_skip_destroy
  ecs_tags                     = var.ecs_tags
  ecs_task_role_arn            = var.ecs_task_role_arn
  ecs_track_latest             = var.ecs_track_latest
  ecs_volumes                  = var.ecs_volumes

  # Container definition inputs
  container_command                  = var.container_command
  container_cpu                      = var.container_cpu
  container_depends_on               = var.container_depends_on
  container_disable_networking       = var.container_disable_networking
  container_dns_search_domains       = var.container_dns_search_domains
  container_dns_servers              = var.container_dns_servers
  container_docker_labels            = var.container_docker_labels
  container_docker_security_options  = var.container_docker_security_options
  container_entry_point              = var.container_entry_point
  container_environment              = var.container_environment
  container_environment_files        = var.container_environment_files
  container_essential                = var.container_essential
  container_extra_hosts              = var.container_extra_hosts
  container_firelens_configuration   = var.container_firelens_configuration
  container_health_check             = var.container_health_check
  container_hostname                 = var.container_hostname
  container_image                    = var.container_image
  container_interactive              = var.container_interactive
  container_links                    = var.container_links
  container_linux_parameters         = var.container_linux_parameters
  container_memory                   = var.container_memory
  container_memory_reservation       = var.container_memory_reservation
  container_mount_points             = var.container_mount_points
  container_name                     = var.container_name
  container_portmappings             = var.container_portmappings
  container_privileged               = var.container_privileged
  container_pseudo_terminal          = var.container_pseudo_terminal
  container_readonly_root_filesystem = var.container_readonly_root_filesystem
  container_resource_requirements    = var.container_resource_requirements
  container_secrets                  = var.container_secrets
  container_start_timeout            = var.container_start_timeout
  container_stop_timeout             = var.container_stop_timeout
  container_system_controls          = var.container_system_controls
  container_ulimits                  = var.container_ulimits
  container_user                     = var.container_user
  container_volumes_from             = var.container_volumes_from
  container_working_directory        = var.container_working_directory

  # CloudWatch Logs
  aws_region            = var.aws_region
  awslogs_group         = var.awslogs_group
  awslogs_stream_prefix = var.awslogs_stream_prefix
}

module "yc" {
  source = "./modules/yc"
  count  = (var.yc_vm_create || var.yc_serverless_create) ? 1 : 0

  labels = local.labels

  # Creation toggles + prefix
  yc_vm_create         = var.yc_vm_create
  yc_serverless_create = var.yc_serverless_create
  yc_prefix            = var.yc_prefix

  # Shared YC metadata
  cloud-init         = var.cloud-init
  service_account_id = var.service_account_id
  timeout            = var.timeout
  vault-token        = var.vault-token

  # YC VM inputs
  allow_stopping_for_update = var.allow_stopping_for_update
  boot_disk                 = var.boot_disk
  core_fraction             = var.core_fraction
  creation_zone             = var.creation_zone
  filesystem                = var.filesystem
  local_disk                = var.local_disk
  metadata_options          = var.metadata_options
  network_acceleration_type = var.network_acceleration_type
  placement_policy          = var.placement_policy
  scheduling_policy         = var.scheduling_policy
  secondary_disk            = var.secondary_disk
  source_image_family       = var.source_image_family
  source_image_id           = var.source_image_id
  vm_ram_qty                = var.vm_ram_qty
  vm_vcpu_qty               = var.vm_vcpu_qty
  vm_vcpu_type              = var.vm_vcpu_type
  yc_network_interface      = var.yc_network_interface

  # YC Serverless inputs
  serverless_async_invocation  = var.serverless_async_invocation
  serverless_concurrency       = var.serverless_concurrency
  serverless_connectivity      = var.serverless_connectivity
  serverless_core_fraction     = var.serverless_core_fraction
  serverless_cores             = var.serverless_cores
  serverless_description       = var.serverless_description
  serverless_execution_timeout = var.serverless_execution_timeout
  serverless_image             = var.serverless_image
  serverless_log_options       = var.serverless_log_options
  serverless_memory            = var.serverless_memory
  serverless_metadata_options  = var.serverless_metadata_options
  serverless_mounts            = var.serverless_mounts
  serverless_provision_policy  = var.serverless_provision_policy
  serverless_runtime           = var.serverless_runtime
  serverless_secrets           = var.serverless_secrets
}
