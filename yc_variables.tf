#################################################
#                                               #
#               YC VM variables                 #
#                                               #
#################################################

variable "source_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "(Optional) The family name of an image. Used to search the latest image in a family."
}

variable "source_image_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of a specific image."
}


variable "yc_vm_create" {
  description = "Whether to create a Yandex Cloud compute instance. Set to `true` to provision a VM with the specified resources and network configuration"
  type        = bool
  default     = false
}


variable "creation_zone" {
  type        = string
  description = "(Mandatory) Zone where resources will be created"
  default     = "ru-central1-a"

}

variable "yc_prefix" {
  description = "Naming prefix appended to all Yandex Cloud resource names (e.g. VM hostname, serverless container name)"
  type        = string
  default     = "gosling-runner"
}


variable "vm_vcpu_type" {
  description = "Yandex Cloud platform ID that determines the CPU generation and type (e.g. `standard-v2` for Intel Cascade Lake, `standard-v3` for Intel Ice Lake, `gpu-standard-v2` for GPU instances)"
  type        = string
  default     = "standard-v2"
}

variable "core_fraction" {
  type        = number
  default     = null
  description = "(Optional) If provided, specifies baseline performance for a core as a percent."
}

variable "allow_stopping_for_update" {
  type        = bool
  default     = true
  description = <<-EOT
    (Optional) If true, allows Terraform to stop the instance in order to update its properties.
    If you try to update a property that requires stopping the instance without setting this field, the update will fail.
    EOT

}

variable "network_acceleration_type" {
  type        = string
  default     = "standard"
  description = "(Optional) Type of network acceleration. The default is standard. Values: standard, software_accelerated"
  validation {
    condition     = var.network_acceleration_type == "standard" || var.network_acceleration_type == "software_accelerated"
    error_message = "Only two possible values could be inputed - standard, software_accelerated"
  }

}

variable "vm_vcpu_qty" {
  type        = number
  default     = 2
  description = "(Required) Number of virtual CPU cores for the instance. Must be compatible with the chosen `vm_vcpu_type` platform (e.g. standard-v2 supports 2, 4, 8, 16, 32, etc.)"
}


variable "vm_ram_qty" {
  type        = number
  default     = 2
  description = "(Required) Memory size in GB. Must be compatible with the chosen platform and core count (minimum 1 GB per core for standard platforms)"
}

variable "metadata_options" {
  type        = any
  default     = {}
  description = "(Optional) Options to configure access to the instance metadata service. Supports `aws_v1_http_endpoint`, `aws_v1_http_token`, `gce_http_endpoint`, and `gce_http_token` (each accepting values 1=enabled, 2=disabled)"
}

variable "placement_policy" {
  type        = list(any)
  default     = []
  description = <<-EOT
  (Optional) The placement policy configuration. The structure is documented below.
  The placement_policy block supports:

    placement_group_id - (Optional) Specifies the id of the Placement Group to assign to the instance.

    host_affinity_rules - (Optional) List of host affinity rules. The structure is documented below.

  The host_affinity_rules block supports:

    key - (Required) Affinity label or one of reserved values - yc.hostId, yc.hostGroupId.

    op - (Required) Affinity action. The only value supported is IN.

    value - (Required) List of values (host IDs or host group IDs).

  EOT
}

variable "scheduling_policy" {
  type        = any
  default     = {}
  description = <<-EOT
  (Optional) Scheduling policy configuration. The structure is documented below.
  The scheduling_policy block supports:

    preemptible - (Optional) Specifies if the instance is preemptible. Defaults to false.

  EOT
}

variable "boot_disk" {
  description = <<-EOT
  (Required) The boot disk for the instance. The structure is documented below."
  The boot_disk block supports:

    auto_delete - (Optional) Defines whether the disk will be auto-deleted when the instance is deleted. The default value is True.

    device_name - (Optional) Name that can be used to access an attached disk.

    mode - (Optional) Type of access to the disk resource. By default, a disk is attached in READ_WRITE mode.

    disk_id - (Optional) The ID of the existing disk (such as those managed by yandex_compute_disk) to attach as a boot disk.

    initialize_params - (Optional) Parameters for a new disk that will be created alongside the new instance. Either initialize_params or disk_id must be set. The structure is documented below.

  The initialize_params block supports:

    name - (Optional) Name of the boot disk.

    description - (Optional) Description of the boot disk.

    size - (Optional) Size of the disk in GB.

    block_size - (Optional) Block size of the disk, specified in bytes.

    type - (Optional) Disk type.

    image_id - (Optional) A disk image to initialize this disk from.

    snapshot_id - (Optional) A snapshot to initialize this disk from.

  EOT
  type        = any
  default     = {}
}

variable "secondary_disk" {
  description = <<-EOT
  (Optional) A list of disks to attach to the instance. The structure is documented below.
  Note: The allow_stopping_for_update property must be set to true in order to update this structure.
  The secondary_disk block supports:

    disk_id - (Required) ID of the disk that is attached to the instance.

    auto_delete - (Optional) Whether the disk is auto-deleted when the instance is deleted. The default value is false.

    device_name - (Optional) Name that can be used to access an attached disk under /dev/disk/by-id/.

    mode - (Optional) Type of access to the disk resource. By default, a disk is attached in READ_WRITE mode.

  EOT
  type        = list(any)
  default     = []
}

variable "local_disk" {
  type        = list(any)
  default     = []
  description = <<-EOT
  (Optional) List of local disks that are attached to the instance. Structure is documented below.
  The local_disk block supports:

    size_bytes - (Required) Size of the disk, specified in bytes.

  NOTE:

  Local disks are not available for all users by default.
  EOT
}

variable "filesystem" {
  type        = list(any)
  default     = []
  description = <<-EOT
  (Optional) List of filesystems that are attached to the instance. Structure is documented below.
  The filesystem block supports:

    filesystem_id - (Required) ID of the filesystem that should be attached.

    device_name - (Optional) Name of the device representing the filesystem on the instance.

    mode - (Optional) Mode of access to the filesystem that should be attached. By default, filesystem is attached in READ_WRITE mode.

  EOT
}

variable "yc_network_interface" {
  type        = any
  default     = {}
  description = <<-EOT
  (Required) Networks to attach to the instance. This can be specified multiple times. The structure is documented below.
  The network_interface block supports:

    subnet_id - (Required) ID of the subnet to attach this interface to. The subnet must exist in the same zone where this instance will be created.

    ipv4 - (Optional) Allocate an IPv4 address for the interface. The default value is true.

    ip_address - (Optional) The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet.

    ipv6 - (Optional) If true, allocate an IPv6 address for the interface. The address will be automatically assigned from the specified subnet.

    ipv6_address - (Optional) The private IPv6 address to assign to the instance.

    nat - (Optional) Provide a public address, for instance, to access the internet over NAT.

    nat_ip_address - (Optional) Provide a public address, for instance, to access the internet over NAT. Address should be already reserved in web UI.

    security_group_ids - (Optional) Security group ids for network interface.

    dns_record - (Optional) List of configurations for creating ipv4 DNS records. The structure is documented below.

    ipv6_dns_record - (Optional) List of configurations for creating ipv6 DNS records. The structure is documented below.

    nat_dns_record - (Optional) List of configurations for creating ipv4 NAT DNS records. The structure is documented below.

  The dns_record block supports:

    fqdn - (Required) DNS record FQDN (must have a dot at the end).

    dns_zone_id - (Optional) DNS zone ID (if not set, private zone used).

    ttl - (Optional) DNS record TTL. in seconds

    ptr - (Optional) When set to true, also create a PTR DNS record.

  The ipv6_dns_record block supports:

    fqdn - (Required) DNS record FQDN (must have a dot at the end).

    dns_zone_id - (Optional) DNS zone ID (if not set, private zone used).

    ttl - (Optional) DNS record TTL. in seconds

    ptr - (Optional) When set to true, also create a PTR DNS record.

  The nat_dns_record block supports:

    fqdn - (Required) DNS record FQDN (must have a dot at the end).

    dns_zone_id - (Optional) DNS zone ID (if not set, private zone used).

    ttl - (Optional) DNS record TTL. in seconds

    ptr - (Optional) When set to true, also create a PTR DNS record.

  EOT

}


variable "group" {
  type        = string
  default     = "application"
  description = "(Optional) Logical host group label used for resource tagging and identification (e.g. `application`, `database`, `monitoring`)"
}

variable "timeout" {
  type        = string
  default     = "15m"
  description = "(Optional) Maximum duration to wait for resource creation, update, and deletion operations (e.g. `15m`, `30m`, `1h`)"
}

variable "cloud-init" {
  nullable    = true
  default     = null
  type        = string
  description = "(Optional) Cloud-init user data script or configuration (YAML/shell). Passed to the instance metadata as `user-data` for automated provisioning on first boot"
}

variable "vault-token" {
  type        = string
  default     = null
  sensitive   = true
  description = "(Optional) Temporary HashiCorp Vault token passed via instance metadata for secret retrieval during provisioning. Should be short-lived and scoped to the deployment"
}

#################################################
#                                               #
#           YC Serverless variables             #
#                                               #
#################################################

variable "yc_serverless_create" {
  description = "Whether to create a Yandex Cloud Serverless Container. Set to `true` to deploy a container revision with the specified image, connectivity, and scaling policies"
  type        = bool
  default     = false
}

variable "serverless_image" {
  type = object({
    url         = string
    args        = optional(list(string))
    command     = optional(list(string))
    digest      = optional(string)
    environment = optional(map(string))
    work_dir    = optional(string)
  })
  default = {
    url = "dummy"
  }
  description = <<-EOT
  ```
  (Required) The image for the serverless instance. The structure is documented below.
  The image block supports:
    url - (Required) (String) URL of image that will be deployed as Yandex Cloud Serverless Container.
    args - (Optional) (List of String) List of arguments for Yandex Cloud Serverless Container.
    command - (Optional) (List of String) List of commands for Yandex Cloud Serverless Container.
    digest - (Optional) (String) Digest of image that will be deployed as Yandex Cloud Serverless Container.
             if presented, should be equal to digest that will be resolvet at server side by URL.
             Container will be updated on digest change even if image.0.url stays the same. If field not
             specified then its value will be computed.
    environment - (Optional) (Map of String) A set of key/value environment variables pairs
                  for Yandex Cloud Serverless Container. Each key must begin with a letter (A-Z,a-z).
    work_dir - (Optional) (String) Working directory for Yandex Cloud Serverless Container.
  ```
  EOT
}

variable "serverless_connectivity" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Required) The connectivity settings for the serverless instance. The structure is documented below.
  The connectivity block supports:
    network_id - (Required) (String) Network the revision will have access to.
  ```
  EOT
}

variable "serverless_log_options" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) The log options for the serverless instance. The structure is documented below.
  The log_options block supports:
    disabled - (Optional) (Boolean) is logging from container disabled.
    folder_id - (Optional) (String) Log entries are written to default log group for specific folder.
    log_group_id - (Optional) (String) Log entries are written to specified log group.
    min_level - (Optional) (String) Minimum log entry level.
  ```
  EOT
}

variable "serverless_metadata_options" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) The metadata options for the serverless instance. The structure is documented below.
  The metadata_options block supports:
    aws_v1_http_endpoint - (Number) Enables access to AWS flavored metadata (IMDSv1).
                           Values: 0 - default, 1 - enabled, 2 - disabled.
    gce_http_endpoint - (Number) Enables access to GCE flavored metadata.
                        Values: 0 - default, 1 - enabled, 2 - disabled.
  ```
  EOT

  validation {
    condition = (
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "aws_v1_http_endpoint", 0)) &&
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "gce_http_endpoint", 0))
    ) || var.serverless_metadata_options == {}
    error_message = "Only three possible values could be inputed for aws_v1_http_endpoint and gce_http_endpoint - 0, 1, 2"
  }
}

variable "serverless_mounts" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) The mounts for the serverless instance. The structure is documented below.
  The mounts block supports:
    mount_point_path - (Required) (String) Path inside the container to access the directory in which the target
                        is mounted.
    mode - (Required) (String)  Mount's accessibility mode. Valid values are ro and rw.
    ephemeral_disk - (Optional) (Block) Ephemeral disk configuration. The structure is documented below.
    object_storage - (Optional) (Block) Object storage configuration. The structure is documented below.
  The ephemeral_disk block supports:
      size_gb - (Required) (Number) Size of the ephemeral disk in GB.
      block_size_kb - (Optional) (Number) Block size of the ephemeral disk in KB.
  The object_storage block supports:
      bucket - (Required) (String) Name of the object storage bucket.
      prefix - (Optional) (String) Prefix within the bucket. If you leave this field empty, the entire
               bucket will be mounted.
  ```
  EOT
  validation {
    condition = (
      length(try(var.serverless_mounts["ephemeral_disk"], [])) <= 1 &&
      length(try(var.serverless_mounts["object_storage"], [])) <= 1
      ) && (
      try(var.serverless_mounts["mode"], "rw") == "ro" || try(var.serverless_mounts["mode"], "rw") == "rw"
    ) || var.serverless_mounts == {}
    error_message = <<-EOT
      Only one of ephemeral_disk or object_storage can be specified per mount.
      Also, only two possible values could be inputed for mode - ro, rw.
    EOT
  }
}

variable "serverless_provision_policy" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) The provision policy for the serverless instance. The structure is documented below.
  The provision_policy block supports:
    min_instances - (Required) (Number) Minimum number of prepared instances that that are always
                    ready to serve requests.
  ```
  EOT
}

variable "serverless_runtime" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) (String) Runtime for Yandex Cloud Serverless Container. The structure is documented below.
  The runtime block supports:
    type - (Required) (String) Type of the runtime for Yandex Cloud Serverless Container. Valid values are http and task.
  ```
  EOT

  validation {
    condition = (
      try(var.serverless_runtime["type"], "http") == "http" ||
      try(var.serverless_runtime["type"], "http") == "task"
    ) || var.serverless_runtime == {}
    error_message = "Only two possible values could be inputed for type - http, task"
  }

}

variable "serverless_secrets" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) The secrets for the serverless instance. The structure is documented below.
  The secrets block supports:
    environment_variable - (Required) (String) Container's evironment variable in which secret's value will be stored.
                           Must begin with a letter (A-Z,a-z).
    id - (Required) (String) Secret's ID.
    key - (Required) (String) Secret's entries key which value will be stored in environment variable.
    version_id - (Optional) (String) Secret's varion ID.
  ```
  EOT
  validation {
    condition = (
      length(regexall("^[A-Za-z]", try(var.serverless_secrets["environment_variable"], "A"))) > 0
    ) || var.serverless_secrets == {}
    error_message = "Environment variable must begin with a letter (A-Z,a-z)."
  }
}

variable "serverless_async_invocation" {
  type        = map(any)
  default     = {}
  description = <<-EOT
  ```
  (Optional) Config for asynchronous invocations of Yandex Cloud Serverless Container. The structure is documented below.
  The async_invocation block supports:
    service_account_id - (Optional) (String) Service account used for async invocation.
  ```
  EOT

}

variable "serverless_description" {
  type        = string
  description = "(Optional) Human-readable description for the Yandex Cloud Serverless Container. Displayed in the console and API responses"
  default     = null
}

variable "serverless_memory" {
  type        = number
  description = "(Required) Memory allocation in megabytes for the serverless container revision. Must be aligned to 128 MB (e.g. 128, 256, 512, 1024)"
  default     = 128
}

variable "serverless_cores" {
  type        = number
  description = "(Optional) Number of CPU cores (1 or more) allocated to the serverless container revision. Higher core counts improve compute performance but increase cost"
  default     = null
}

variable "serverless_concurrency" {
  type        = number
  description = "(Optional) Maximum number of concurrent requests a single container instance can handle simultaneously before scaling out"
  default     = null
}

variable "serverless_core_fraction" {
  type        = number
  description = "(Optional) Guaranteed share of CPU time as a percentage (5, 20, 50, or 100). Lower fractions reduce cost but may throttle under sustained load"
  default     = null
}

variable "serverless_execution_timeout" {
  type        = string
  description = "(Optional) Maximum execution timeout for a single request in duration format (e.g. `60s`, `300s`, `3600s`). The container is terminated if a request exceeds this duration"
  default     = null
}

#################################################
#                                               #
#           Common variables                    #
#                                               #
#################################################

variable "additional_labels" {
  type        = map(any)
  default     = null
  description = "(Optional) Map of additional labels/tags to attach to all created resources. Merged with the module's computed labels (`created_at`, `owner`, `group`)"
}

variable "owner" {
  type        = string
  description = "(Optional) Owner identifier added to resource labels for cost allocation and accountability tracking"
  default     = "polar-team"
}

variable "service_account_id" {
  type        = string
  default     = null
  description = "(Optional) ID of the Yandex Cloud service account assigned to the instance or serverless container. Grants the resource permissions to access other cloud services (e.g. Container Registry, Object Storage)"
}

