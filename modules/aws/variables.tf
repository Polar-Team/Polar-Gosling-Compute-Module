#################################################
#                                               #
#           Labels (injected by root)           #
#                                               #
#################################################

variable "labels" {
  description = "Map of labels/tags computed at the root module and merged into AWS resource tags"
  type        = map(string)
  default     = {}
}

#################################################
#                                               #
#               AWS VM variables                #
#                                               #
#################################################

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "aws_vm_create" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = false
}

variable "aws_prefix" {
  description = "Naming prefix appended to all AWS resource names and tags"
  type        = string
  default     = "gosling-runner"
}

variable "ami" {
  description = "ID of AMI to use for the instance. If null, resolved via the SSM parameter"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  type    = bool
  default = null
}

variable "maintenance_options" {
  type    = any
  default = {}
}

variable "availability_zone" {
  type    = string
  default = null
}

variable "capacity_reservation_specification" {
  type    = any
  default = {}
}

variable "cpu_credits" {
  type    = string
  default = null
}

variable "disable_api_termination" {
  type    = bool
  default = null
}

variable "ebs_block_device" {
  type    = list(any)
  default = []
}

variable "ebs_optimized" {
  type    = bool
  default = null
}

variable "enclave_options_enabled" {
  type    = bool
  default = null
}

variable "ephemeral_block_device" {
  type    = list(map(string))
  default = []
}

variable "get_password_data" {
  type    = bool
  default = null
}

variable "hibernation" {
  type    = bool
  default = null
}

variable "host_id" {
  type    = string
  default = null
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "instance_initiated_shutdown_behavior" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_tags" {
  type    = map(string)
  default = {}
}

variable "ipv6_address_count" {
  type    = number
  default = null
}

variable "ipv6_addresses" {
  type    = list(string)
  default = null
}

variable "key_name" {
  type    = string
  default = null
}

variable "launch_template" {
  type    = map(string)
  default = {}
}

variable "aws_metadata_options" {
  type = map(string)
  default = {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 1
    "http_tokens"                 = "optional"
  }
}

variable "monitoring" {
  type    = bool
  default = null
}

variable "aws_network_interface" {
  type    = list(map(string))
  default = []
}

variable "private_dns_name_options" {
  type    = map(string)
  default = {}
}

variable "placement_group" {
  type    = string
  default = null
}

variable "private_ip" {
  type    = string
  default = null
}

variable "root_block_device" {
  type    = list(any)
  default = []
}

variable "secondary_private_ips" {
  type    = list(string)
  default = null
}

variable "source_dest_check" {
  type    = bool
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "tenancy" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "user_data_base64" {
  type    = string
  default = null
}

variable "user_data_replace_on_change" {
  type    = bool
  default = null
}

variable "volume_tags" {
  type    = map(string)
  default = {}
}

variable "enable_volume_tags" {
  type    = bool
  default = true
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = null
}

variable "timeouts" {
  type    = map(string)
  default = {}
}

variable "cpu_options" {
  type    = any
  default = {}
}

variable "disable_api_stop" {
  type    = bool
  default = null
}

#################################################
#                                               #
#             AWS ECS variables                 #
#                                               #
#################################################

variable "ecs_settings" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
  validation {
    condition     = alltrue([for s in var.ecs_settings : contains(["containerInsights"], s.name)])
    error_message = "Setting name must be 'containerInsights'."
  }
  validation {
    condition     = alltrue([for s in var.ecs_settings : s.name != "containerInsights" || contains(["enabled", "disabled"], s.value)])
    error_message = "When setting name is 'containerInsights', value must be 'enabled' or 'disabled'."
  }
}

variable "ecs_configurations" {
  type = list(object({
    execute_command_configuration = optional(list(object({
      logging    = optional(string)
      kms_key_id = optional(string)
      log_configuration = optional(list(object({
        cloud_watch_log_group_name     = optional(string)
        cloud_watch_encryption_enabled = optional(bool)
        s3_bucket_name                 = optional(string)
        s3_bucket_encryption_enabled   = optional(bool)
        s3_key_prefix                  = optional(string)
      })))
    })))
    managed_storage_configuration = optional(list(object({
      fargate_ephemeral_storage_kms_key_id = optional(string)
      kms_key_id                           = optional(string)
    })))
  }))
  default = []
  validation {
    condition = alltrue(flatten([
      for config in var.ecs_configurations : [
        for exec_config in coalesce(config.execute_command_configuration, []) :
        exec_config.logging == null || contains(["NONE", "DEFAULT", "OVERRIDE"], exec_config.logging)
      ]
    ]))
    error_message = "Execute command logging must be one of: NONE, DEFAULT, or OVERRIDE."
  }
}

variable "ecs_service_connect_defaults" {
  type = list(object({
    namespace = string
  }))
  default = []
  validation {
    condition     = length(var.ecs_service_connect_defaults) <= 1
    error_message = "Only one service_connect_defaults block is allowed per cluster."
  }
}

variable "aws_ecs_create" {
  type    = bool
  default = false
}

variable "ecs_network_mode" {
  type    = string
  default = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.ecs_network_mode)
    error_message = "The network_mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "ecs_ipc_mode" {
  type    = string
  default = null
  validation {
    condition     = var.ecs_ipc_mode == null || contains(["host", "task", "none"], var.ecs_ipc_mode)
    error_message = "The ipc_mode must be one of: host, task, none."
  }
}

variable "ecs_pid_mode" {
  type    = string
  default = null
  validation {
    condition     = var.ecs_pid_mode == null || contains(["host", "task"], var.ecs_pid_mode)
    error_message = "The pid_mode must be one of: host, task."
  }
}

variable "ecs_enable_fault_injection" {
  type    = bool
  default = false
}

variable "ecs_skip_destroy" {
  type    = bool
  default = false
}

variable "ecs_requires_compatibilities" {
  type    = list(string)
  default = ["FARGATE"]
  validation {
    condition     = alltrue([for v in var.ecs_requires_compatibilities : contains(["EC2", "FARGATE", "EXTERNAL"], v)])
    error_message = "All values in requires_compatibilities must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "ecs_cpu" {
  type    = number
  default = 256
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384], var.ecs_cpu)
    error_message = "CPU must be one of the valid values: 256, 512, 1024, 2048, 4096, 8192, 16384."
  }
}

variable "ecs_memory" {
  type    = number
  default = 512
}

variable "ecs_execution_role_arn" {
  type    = string
  default = null
}

variable "ecs_task_role_arn" {
  type    = string
  default = null
}

variable "ecs_tags" {
  type    = map(string)
  default = {}
}

variable "ecs_track_latest" {
  type    = bool
  default = false
}

variable "ecs_volumes" {
  type = list(object({
    name                = string
    host_path           = optional(string)
    configure_at_launch = optional(bool)
    docker_volume_configuration = optional(object({
      scope         = optional(string)
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
    }))
    fsx_windows_file_server_volume_configuration = optional(object({
      file_system_id = string
      root_directory = string
      authorization_config = object({
        credentials_parameter = string
        domain                = string
      })
    }))
  }))
  default = []
}

variable "ecs_runtime_platform" {
  type = list(object({
    cpu_architecture        = optional(string)
    operating_system_family = optional(string)
  }))
  default = []
}

variable "ecs_placement_constraints" {
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
  validation {
    condition     = alltrue([for c in var.ecs_placement_constraints : contains(["memberOf", "distinctInstance"], c.type)])
    error_message = "Placement constraint type must be one of: memberOf, distinctInstance."
  }
}

variable "ecs_proxy_configuration" {
  type = list(object({
    type           = optional(string)
    container_name = string
    properties     = map(string)
  }))
  default = []
}

variable "ecs_ephemeral_storage" {
  type = list(object({
    size_in_gib = number
  }))
  default = []
  validation {
    condition     = alltrue([for s in var.ecs_ephemeral_storage : s.size_in_gib >= 21 && s.size_in_gib <= 200])
    error_message = "Ephemeral storage size must be between 21 GiB and 200 GiB."
  }
}

#################################################
#                                               #
#          AWS ECS container variables          #
#                                               #
#################################################

variable "container_name" {
  type    = string
  default = null
}

variable "container_image" {
  type    = string
  default = null
}

variable "container_cpu" {
  type    = number
  default = null
}

variable "container_memory" {
  type    = number
  default = null
}

variable "container_essential" {
  type    = bool
  default = null
}

variable "container_memory_reservation" {
  type    = number
  default = null
}

variable "container_portmappings" {
  type = list(object({
    container_port = number
    host_port      = optional(number)
    protocol       = optional(string)
    name           = optional(string)
    app_protocol   = optional(string)
  }))
  default = null
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "container_environment_files" {
  type = list(object({
    value = string
    type  = string
  }))
  default = null
}

variable "container_secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = null
}

variable "container_depends_on" {
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = null
}

variable "container_links" {
  type    = list(string)
  default = null
}

variable "container_volumes_from" {
  type = list(object({
    sourceContainer = string
    readOnly        = optional(bool)
  }))
  default = null
}

variable "container_mount_points" {
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = optional(bool)
  }))
  default = null
}

variable "container_linux_parameters" {
  type = object({
    capabilities = optional(object({
      add  = optional(list(string))
      drop = optional(list(string))
    }))
    devices = optional(list(object({
      hostPath      = string
      containerPath = optional(string)
      permissions   = optional(list(string))
    })))
    initProcessEnabled = optional(bool)
    sharedMemorySize   = optional(number)
    tmpfs = optional(list(object({
      containerPath = string
      size          = number
      mountOptions  = optional(list(string))
    })))
    maxSwap    = optional(number)
    swappiness = optional(number)
  })
  default = null
}

variable "container_hostname" {
  type    = string
  default = null
}

variable "container_user" {
  type    = string
  default = null
}

variable "container_working_directory" {
  type    = string
  default = null
}

variable "container_disable_networking" {
  type    = bool
  default = null
}

variable "container_privileged" {
  type    = bool
  default = null
}

variable "container_readonly_root_filesystem" {
  type    = bool
  default = null
}

variable "container_dns_servers" {
  type    = list(string)
  default = null
}

variable "container_dns_search_domains" {
  type    = list(string)
  default = null
}

variable "container_extra_hosts" {
  type = list(object({
    hostname  = string
    ipAddress = string
  }))
  default = null
}

variable "container_docker_security_options" {
  type    = list(string)
  default = null
}

variable "container_docker_labels" {
  type    = map(string)
  default = null
}

variable "container_ulimits" {
  type = list(object({
    name      = string
    softLimit = number
    hardLimit = number
  }))
  default = null
}

variable "container_command" {
  type    = list(string)
  default = null
}

variable "container_entry_point" {
  type    = list(string)
  default = null
}

variable "container_health_check" {
  type = object({
    command     = list(string)
    interval    = optional(number)
    timeout     = optional(number)
    retries     = optional(number)
    startPeriod = optional(number)
  })
  default = null
}

variable "container_start_timeout" {
  type    = number
  default = null
}

variable "container_stop_timeout" {
  type    = number
  default = null
}

variable "container_system_controls" {
  type = list(object({
    namespace = string
    value     = string
  }))
  default = null
}

variable "container_resource_requirements" {
  type = list(object({
    type  = string
    value = string
  }))
  default = null
}

variable "container_firelens_configuration" {
  type = object({
    type    = string
    options = optional(map(string))
  })
  default = null
}

variable "container_interactive" {
  type    = bool
  default = null
}

variable "container_pseudo_terminal" {
  type    = bool
  default = null
}

variable "awslogs_group" {
  type    = string
  default = "/aws/ecs/default"
}

variable "awslogs_stream_prefix" {
  type    = string
  default = "ecs"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
