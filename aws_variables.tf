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
  description = "Naming prefix appended to all AWS resource names and tags (e.g. EC2 instances, ECS clusters)"
  type        = string
  default     = "gosling-runner"
}

variable "ami" {
  description = "ID of AMI to use for the instance. If not provided, the AMI is resolved via the SSM parameter specified in `ami_ssm_parameter`"
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
  description = "The credit option for CPU usage. Valid values: `unlimited` (pay for additional burst capacity) or `standard` (earn credits when idle). Applies only to burstable instance types (T2, T3, T3a)"
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
  description = "The EC2 instance type to launch (e.g. `t3.micro`, `m5.large`). Determines the vCPU, memory, storage, and networking capacity of the instance"
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
  description = "Specifies a Launch Template to configure the instance. Accepted keys: `id`, `name`, `version`. Parameters configured directly on this module's resource will override the corresponding parameters defined in the Launch Template"
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
  description = "Defines CPU options to apply to the instance at launch time. Accepted keys: `core_count` (number of CPU cores), `threads_per_core` (threads per core, set to 1 to disable hyper-threading), `amd_sev_snp` (AMD SEV-SNP support)"
  type        = any
  default     = {}
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection. Prevents the instance from being stopped via the API or console until this protection is disabled"
  type        = bool
  default     = null
}
#################################################
#                                               #
#             AWS ECS variables                 #
#                                               #
#################################################

variable "ecs_settings" {
  description = "List of configuration block(s) with cluster settings. Currently the only supported setting name is `containerInsights` with values `enabled` or `disabled`"
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
  description = "Configuration block for ECS cluster execute-command and managed-storage settings. Execute command logging must be one of: `NONE`, `DEFAULT`, or `OVERRIDE`"
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
  description = "Configures a default Service Connect namespace for the ECS cluster. Only one entry is allowed. Services in the cluster will use this namespace for service-to-service communication via AWS Cloud Map"
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
  description = "Whether to create ECS resources (cluster and task definition). Set to `true` to provision an ECS cluster with a task definition for container workloads"
  type        = bool
  default     = false
}

variable "ecs_network_mode" {
  description = "Docker networking mode for the task's containers. `awsvpc` gives each task its own ENI; `bridge` uses Docker's built-in bridge; `host` maps directly to the host network; `none` disables networking"
  type        = string
  default     = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.ecs_network_mode)
    error_message = "The network_mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "ecs_ipc_mode" {
  description = "IPC resource namespace for the containers in the task. `host` shares the host's IPC namespace; `task` shares among containers in the task; `none` keeps containers isolated. Null uses the Docker daemon default"
  type        = string
  default     = null
  validation {
    condition     = var.ecs_ipc_mode == null || contains(["host", "task", "none"], var.ecs_ipc_mode)
    error_message = "The ipc_mode must be one of: host, task, none."
  }
}

variable "ecs_pid_mode" {
  description = "Process (PID) namespace for the containers in the task. `host` shares the host's PID namespace (containers can see host processes); `task` shares among containers in the task. Null uses the Docker daemon default"
  type        = string
  default     = null
  validation {
    condition     = var.ecs_pid_mode == null || contains(["host", "task"], var.ecs_pid_mode)
    error_message = "The pid_mode must be one of: host, task."
  }
}

variable "ecs_enable_fault_injection" {
  description = "Whether to enable AWS Fault Injection Simulator (FIS) integration for the task definition, allowing chaos-engineering experiments against the task"
  type        = bool
  default     = false
}

variable "ecs_skip_destroy" {
  description = "Whether to retain the old task definition revision when the resource is destroyed or replacement is necessary. Useful when other services still reference previous revisions"
  type        = bool
  default     = false
}

variable "ecs_requires_compatibilities" {
  description = "Set of launch types required by the task. `FARGATE` for serverless containers, `EC2` for self-managed instances, `EXTERNAL` for ECS Anywhere on-premises hosts"
  type        = list(string)
  default     = ["FARGATE"]
  validation {
    condition     = alltrue([for v in var.ecs_requires_compatibilities : contains(["EC2", "FARGATE", "EXTERNAL"], v)])
    error_message = "All values in requires_compatibilities must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "ecs_cpu" {
  description = "Number of CPU units for the task (1024 units = 1 vCPU). Required for FARGATE. Valid values: 256, 512, 1024, 2048, 4096, 8192, 16384"
  type        = number
  default     = 256
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096, 8192, 16384], var.ecs_cpu)
    error_message = "CPU must be one of the valid values: 256, 512, 1024, 2048, 4096, 8192, 16384."
  }
}

variable "ecs_memory" {
  description = "Amount of memory (in MiB) used by the task. Required for FARGATE. Must comply with cpu/memory combinations documented by AWS (e.g. 256 CPU supports 512–2048 MiB)"
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
  description = "Map of additional tags to assign to ECS resources (cluster and task definition). Merged with `tags` and computed labels"
  type        = map(string)
  default     = {}
}

variable "ecs_track_latest" {
  description = "Whether to track the latest ACTIVE task definition revision on each apply, so Terraform detects drift when an external process registers a new revision"
  type        = bool
  default     = false
}

variable "ecs_volumes" {
  description = "List of volume definitions for the ECS task. Supports Docker volumes, EFS file systems, and FSx for Windows File Server. Volumes are referenced by name in container `mountPoints`"
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
  description = "Runtime platform configuration for the ECS task. Specifies `cpu_architecture` (`X86_64` or `ARM64`) and `operating_system_family` (e.g. `LINUX`, `WINDOWS_SERVER_2019_FULL`)"
  type = list(object({
    cpu_architecture        = optional(string)
    operating_system_family = optional(string)
  }))
  default = []
}

variable "ecs_placement_constraints" {
  description = "Placement constraint rules for task placement. `memberOf` uses a cluster query expression; `distinctInstance` ensures each task runs on a separate instance"
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
  description = "Configuration block for the AWS App Mesh proxy sidecar. Specifies the proxy container name and the properties map passed to the proxy (e.g. `AppPorts`, `EgressIgnoredIPs`)"
  type = list(object({
    type           = optional(string)
    container_name = string
    properties     = map(string)
  }))
  default = []
}

variable "ecs_ephemeral_storage" {
  description = "Ephemeral storage (in GiB) for the Fargate task. Must be between 21 and 200 GiB. The default Fargate ephemeral storage is 20 GiB when this block is omitted"
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
  description = "Name of the container within the ECS task definition. Used for referencing in dependencies, port mappings, and logging. Defaults to `app-container` if null"
  type        = string
  default     = null
}

variable "container_image" {
  description = "Docker image URI to use for the container (e.g. `nginx:latest` or `123456789.dkr.ecr.us-east-1.amazonaws.com/app:v1`). Defaults to `nginx:latest` if null"
  type        = string
  default     = null
}

variable "container_cpu" {
  description = "CPU units to allocate to the container (1024 units = 1 vCPU). For Fargate, the sum of all containers' CPU must not exceed the task-level `ecs_cpu`. Defaults to 256 if null"
  type        = number
  default     = null
}

variable "container_memory" {
  description = "Hard memory limit (in MiB) for the container. If the container exceeds this limit, it is killed. Defaults to 512 if null"
  type        = number
  default     = null
}

variable "container_essential" {
  description = "Whether the container is essential. If an essential container stops or fails, all other containers in the task are stopped. Defaults to `true` if null"
  type        = bool
  default     = null
}

variable "container_memory_reservation" {
  description = "Soft memory limit (in MiB) reserved for the container. The container can burst above this, but ECS uses it for placement decisions. Defaults to 256 if null"
  type        = number
  default     = null
}

variable "container_portmappings" {
  description = "Port mappings for the container. Maps container ports to host ports. For `awsvpc` network mode, `host_port` must equal `container_port` or be omitted"
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
  description = "Environment variables to pass to the container at startup. Each entry requires a `name` and `value` pair"
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "container_environment_files" {
  description = "S3-hosted environment files (.env) to inject into the container. Each entry requires `value` (S3 ARN) and `type` (must be `s3`)"
  type = list(object({
    value = string
    type  = string
  }))
  default = null
}

variable "container_secrets" {
  description = "Secrets to inject as environment variables in the container. `valueFrom` is the ARN of the secret in Secrets Manager or SSM Parameter Store"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = null
}

variable "container_depends_on" {
  description = "Container startup/shutdown dependencies. Specifies other containers that must reach a given `condition` (`START`, `COMPLETE`, `SUCCESS`, or `HEALTHY`) before this container starts"
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = null
}

variable "container_links" {
  description = "Links to other containers in the same task (Docker `--link` flag). Only supported in `bridge` network mode. Enables hostname-based communication between containers"
  type        = list(string)
  default     = null
}

variable "container_volumes_from" {
  description = "Data volumes to mount from another container in the same task. Inherits the mount points from the `sourceContainer`"
  type = list(object({
    sourceContainer = string
    readOnly        = optional(bool)
  }))
  default = null
}

variable "container_mount_points" {
  description = "Mount points for data volumes in the container. Maps a task-level volume name (`sourceVolume`) to a path inside the container (`containerPath`)"
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = optional(bool)
  }))
  default = null
}

variable "container_linux_parameters" {
  description = "Linux-specific options for the container. Includes kernel capabilities (add/drop), devices, init process, shared memory, tmpfs mounts, swap, and swappiness settings"
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
  description = "Hostname to use for the container. Only available with `bridge` network mode"
  type        = string
  default     = null
}

variable "container_user" {
  description = "User to run as inside the container. Format: `user`, `uid`, `user:group`, or `uid:gid`"
  type        = string
  default     = null
}

variable "container_working_directory" {
  description = "Working directory inside the container (absolute path). Overrides the Docker image's WORKDIR instruction"
  type        = string
  default     = null
}

variable "container_disable_networking" {
  description = "When true, networking is disabled within the container. Only supported with `none` network mode"
  type        = bool
  default     = null
}

variable "container_privileged" {
  description = "When true, the container is given elevated privileges on the host (similar to `docker run --privileged`). Not supported on Fargate"
  type        = bool
  default     = null
}

variable "container_readonly_root_filesystem" {
  description = "When true, the container's root filesystem is mounted as read-only. Writes must target mounted volumes. Recommended for security hardening"
  type        = bool
  default     = null
}

variable "container_dns_servers" {
  description = "List of DNS server IP addresses presented to the container. Only supported in `bridge` network mode"
  type        = list(string)
  default     = null
}

variable "container_dns_search_domains" {
  description = "List of DNS search domains presented to the container. Only supported in `bridge` network mode"
  type        = list(string)
  default     = null
}

variable "container_extra_hosts" {
  description = "Extra host entries appended to the container's `/etc/hosts` file. Each entry maps a `hostname` to an `ipAddress`"
  type = list(object({
    hostname  = string
    ipAddress = string
  }))
  default = null
}

variable "container_docker_security_options" {
  description = "Docker security options (e.g. SELinux labels, AppArmor profiles) to apply to the container. Not supported on Fargate"
  type        = list(string)
  default     = null
}

variable "container_docker_labels" {
  description = "Map of key/value metadata labels applied to the Docker container for identification and filtering"
  type        = map(string)
  default     = null
}

variable "container_ulimits" {
  description = "Linux ulimits to set in the container. Each entry specifies a resource `name` (e.g. `nofile`), `softLimit`, and `hardLimit`"
  type = list(object({
    name      = string
    softLimit = number
    hardLimit = number
  }))
  default = null
}

variable "container_command" {
  description = "Command to run in the container, overriding the Docker image's CMD instruction. Passed as exec-form arguments"
  type        = list(string)
  default     = null
}

variable "container_entry_point" {
  description = "Entry point for the container, overriding the Docker image's ENTRYPOINT instruction. Passed as exec-form arguments"
  type        = list(string)
  default     = null
}

variable "container_health_check" {
  description = "Container health check configuration. `command` is the check command (e.g. `[\"CMD-SHELL\", \"curl -f http://localhost/\"]`). Optional `interval`, `timeout`, `retries`, and `startPeriod` (all in seconds)"
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
  description = "Time (in seconds) to wait for a container dependency to resolve before giving up. Only applies when the container has `dependsOn` entries"
  type        = number
  default     = null
}

variable "container_stop_timeout" {
  description = "Time (in seconds) to wait after sending SIGTERM before forcefully killing the container with SIGKILL"
  type        = number
  default     = null
}

variable "container_system_controls" {
  description = "Kernel parameter (sysctl) overrides for the container. Each entry has a `namespace` (e.g. `net.core.somaxconn`) and a `value`"
  type = list(object({
    namespace = string
    value     = string
  }))
  default = null
}

variable "container_resource_requirements" {
  description = "GPU or other accelerator resource requirements for the container. Each entry specifies `type` (e.g. `GPU`, `InferenceAccelerator`) and a `value` (device count or ID)"
  type = list(object({
    type  = string
    value = string
  }))
  default = null
}

variable "container_firelens_configuration" {
  description = "AWS FireLens log router configuration. `type` is either `fluentd` or `fluentbit`. Optional `options` map provides additional configuration passed to the log router"
  type = object({
    type    = string
    options = optional(map(string))
  })
  default = null
}

variable "container_interactive" {
  description = "When true, keeps STDIN open even if not attached (equivalent to `docker run -i`). Useful for interactive debugging sessions"
  type        = bool
  default     = null
}

variable "container_pseudo_terminal" {
  description = "When true, allocates a pseudo-TTY for the container (equivalent to `docker run -t`). Must be used together with `container_interactive`"
  type        = bool
  default     = null
}

variable "awslogs_group" {
  description = "CloudWatch Logs group name where container logs are sent. The log group must already exist or be created outside this module"
  type        = string
  default     = "/aws/ecs/default"
}

variable "awslogs_stream_prefix" {
  description = "Prefix for CloudWatch Logs stream names. Combined with the container name to form the full stream identifier"
  type        = string
  default     = "ecs"
}

variable "aws_region" {
  description = "AWS region where CloudWatch Logs are delivered (e.g. `us-east-1`). Must match the region where the ECS task runs"
  type        = string
  default     = "us-east-1"
}




