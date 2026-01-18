#################################################
#                                               #
#               AWS VM variables                #
#                                               #
#################################################

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html)"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "aws_vm_create" {
  description = "Whether to create an instance"
  type        = bool
  default     = false
}

variable "aws_prefix" {
  type    = string
  default = "gosling-runner"
}


variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}


variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "maintenance_options" {
  description = "The maintenance options for the instance"
  type        = any
  default     = {}
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = any
  default     = {}
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  type        = bool
  default     = null
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "instance_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type        = map(string)
  default     = {}
}

variable "aws_metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default = {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 1
    "http_tokens"                 = "optional"
  }
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = null
}

variable "aws_network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}

variable "private_dns_name_options" {
  description = "Customize the private DNS name options of the instance"
  type        = map(string)
  default     = {}
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`"
  type        = list(string)
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs"
  type        = bool
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set"
  type        = bool
  default     = null
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = map(string)
  default     = {}
}

variable "cpu_options" {
  description = "Defines CPU options to apply to the instance at launch time."
  type        = any
  default     = {}
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection"
  type        = bool
  default     = null

}
#################################################
#                                               #
#             AWS Lamda variables               #
#                                               #
#################################################

variable "ecs_settings" {
  description = "List of configuration block(s) with cluster settings. Valid settings: containerInsights"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for setting in var.ecs_settings :
      contains(["containerInsights"], setting.name)
    ])
    error_message = "Setting name must be 'containerInsights'."
  }

  validation {
    condition = alltrue([
      for setting in var.ecs_settings :
      setting.name != "containerInsights" || contains(["enabled", "disabled"], setting.value)
    ])
    error_message = "When setting name is 'containerInsights', value must be 'enabled' or 'disabled'."
  }
}

variable "ecs_configurations" {
  description = "Configuration block for execute command and managed storage configuration for the cluster"
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
  description = "Configures a default Service Connect namespace. Amazon ECS services running in the cluster can use this namespace for Service Connect"
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
  description = "Whether to create ECS task definition resources"
  type        = bool
  default     = false
}

variable "ecs_network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values: none, bridge, awsvpc, host"
  type        = string
  default     = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.ecs_network_mode)
    error_message = "The network_mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "ecs_ipc_mode" {
  description = "IPC resource namespace to use for the containers in the task. Valid values: host, task, none"
  type        = string
  default     = null
  validation {
    condition     = var.ecs_ipc_mode == null || contains(["host", "task", "none"], var.ecs_ipc_mode)
    error_message = "The ipc_mode must be one of: host, task, none."
  }
}

variable "ecs_pid_mode" {
  description = "Process namespace to use for the containers in the task. Valid values: host, task"
  type        = string
  default     = null
  validation {
    condition     = var.ecs_pid_mode == null || contains(["host", "task"], var.ecs_pid_mode)
    error_message = "The pid_mode must be one of: host, task."
  }
}

variable "ecs_enable_fault_injection" {
  description = "Whether to enable fault injection for the task definition"
  type        = bool
  default     = false
}

variable "ecs_skip_destroy" {
  description = "Whether to retain the old revision when the resource is destroyed or replacement is necessary"
  type        = bool
  default     = false
}

variable "ecs_requires_compatibilities" {
  description = "Set of launch types required by the task. Valid values: EC2, FARGATE, EXTERNAL"
  type        = list(string)
  default     = ["FARGATE"]
  validation {
    condition     = alltrue([for v in var.ecs_requires_compatibilities : contains(["EC2", "FARGATE", "EXTERNAL"], v)])
    error_message = "All values in requires_compatibilities must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "ecs_cpu" {
  description = "Number of CPU units used by the task. Required for FARGATE launch type"
  type        = number
  default     = 256
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384], var.ecs_cpu)
    error_message = "CPU must be one of the valid values: 256, 512, 1024, 2048, 4096, 8192, 16384."
  }
}

variable "ecs_memory" {
  description = "Amount of memory (in MiB) used by the task. Required for FARGATE launch type"
  type        = number
  default     = 512
}

variable "ecs_execution_role_arn" {
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
  type        = string
  default     = null
}

variable "ecs_task_role_arn" {
  description = "ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  type        = string
  default     = null
}

variable "ecs_tags" {
  description = "Map of tags to assign to the ECS task definition"
  type        = map(string)
  default     = {}
}

variable "ecs_track_latest" {
  description = "Whether to track the latest ACTIVE task definition on each apply"
  type        = bool
  default     = false
}

variable "ecs_volumes" {
  description = "List of volume definitions for the task"
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
  description = "Configuration block for runtime platform"
  type = list(object({
    cpu_architecture        = optional(string)
    operating_system_family = optional(string)
  }))
  default = []
}

variable "ecs_placement_constraints" {
  description = "Set of placement constraints rules that are taken into consideration during task placement"
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
  description = "Configuration block for the App Mesh proxy"
  type = list(object({
    type           = optional(string)
    container_name = string
    properties     = map(string)
  }))
  default = []
}

variable "ecs_ephemeral_storage" {
  description = "Amount of ephemeral storage (in GiB) to allocate to the task"
  type = list(object({
    size_in_gib = number
  }))
  default = []
  validation {
    condition     = alltrue([for s in var.ecs_ephemeral_storage : s.size_in_gib >= 21 && s.size_in_gib <= 200])
    error_message = "Ephemeral storage size must be between 21 GiB and 200 GiB."
  }
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = null
}

variable "container_image" {
  description = "Docker image to use for the container"
  type        = string
  default     = null
}

variable "container_cpu" {
  description = "CPU units to allocate to the container"
  type        = number
  default     = null
}

variable "container_memory" {
  description = "Memory (in MiB) to allocate to the container"
  type        = number
  default     = null
}

variable "container_essential" {
  description = "Whether the container is essential"
  type        = bool
  default     = null
}

variable "container_memory_reservation" {
  description = "Soft limit (in MiB) of memory to reserve for the container"
  type        = number
  default     = null
}

variable "container_portmappings" {
  description = "Port mappings for the container"
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
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "container_environment_files" {
  description = "Environment files for the container"
  type = list(object({
    value = string
    type  = string
  }))
  default = null
}

variable "container_secrets" {
  description = "Secrets to pass to the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = null
}

variable "container_depends_on" {
  description = "Container dependencies"
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = null
}

variable "container_links" {
  description = "Links to other containers"
  type        = list(string)
  default     = null
}

variable "container_volumes_from" {
  description = "Data volumes to mount from another container"
  type = list(object({
    sourceContainer = string
    readOnly        = optional(bool)
  }))
  default = null
}

variable "container_mount_points" {
  description = "Mount points for data volumes"
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = optional(bool)
  }))
  default = null
}

variable "container_linux_parameters" {
  description = "Linux-specific options for the container"
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
  description = "Hostname to use for the container"
  type        = string
  default     = null
}

variable "container_user" {
  description = "User to use inside the container"
  type        = string
  default     = null
}

variable "container_working_directory" {
  description = "Working directory in the container"
  type        = string
  default     = null
}

variable "container_disable_networking" {
  description = "Disable networking within the container"
  type        = bool
  default     = null
}

variable "container_privileged" {
  description = "Give extended privileges to the container"
  type        = bool
  default     = null
}

variable "container_readonly_root_filesystem" {
  description = "Mount the container's root filesystem as read-only"
  type        = bool
  default     = null
}

variable "container_dns_servers" {
  description = "List of DNS servers for the container"
  type        = list(string)
  default     = null
}

variable "container_dns_search_domains" {
  description = "List of DNS search domains for the container"
  type        = list(string)
  default     = null
}

variable "container_extra_hosts" {
  description = "Extra hosts to add to /etc/hosts"
  type = list(object({
    hostname  = string
    ipAddress = string
  }))
  default = null
}

variable "container_docker_security_options" {
  description = "Security options for the container"
  type        = list(string)
  default     = null
}

variable "container_docker_labels" {
  description = "Docker labels for the container"
  type        = map(string)
  default     = null
}

variable "container_ulimits" {
  description = "Ulimits for the container"
  type = list(object({
    name      = string
    softLimit = number
    hardLimit = number
  }))
  default = null
}

variable "container_command" {
  description = "Command to run in the container"
  type        = list(string)
  default     = null
}

variable "container_entry_point" {
  description = "Entry point for the container"
  type        = list(string)
  default     = null
}

variable "container_health_check" {
  description = "Health check configuration for the container"
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
  description = "Time duration to wait before giving up on container startup"
  type        = number
  default     = null
}

variable "container_stop_timeout" {
  description = "Time duration to wait before the container is forcefully killed"
  type        = number
  default     = null
}

variable "container_system_controls" {
  description = "System controls (sysctls) for the container"
  type = list(object({
    namespace = string
    value     = string
  }))
  default = null
}

variable "container_resource_requirements" {
  description = "Resource requirements for the container"
  type = list(object({
    type  = string
    value = string
  }))
  default = null
}

variable "container_firelens_configuration" {
  description = "FireLens configuration for the container"
  type = object({
    type    = string
    options = optional(map(string))
  })
  default = null
}

variable "container_interactive" {
  description = "Keep STDIN open even if not attached"
  type        = bool
  default     = null
}

variable "container_pseudo_terminal" {
  description = "Allocate a TTY"
  type        = bool
  default     = null
}

variable "awslogs_group" {
  description = "CloudWatch Logs group name"
  type        = string
  default     = "/aws/ecs/default"
}

variable "awslogs_stream_prefix" {
  description = "CloudWatch Logs stream prefix"
  type        = string
  default     = "ecs"
}

variable "aws_region" {
  description = "AWS region for CloudWatch Logs"
  type        = string
  default     = "us-east-1"
}




