##################Data variables###########################################

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

##################Resourceses variables#####################################


variable "creation_zone" {
  type        = string
  description = "(Mandatory) Zone where resources will be created"

}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) Description of the instance"

}

variable "yc_prefix" {
  type    = string
  default = "goslingwrk"
}

variable "yc_postfix" {
  type        = string
  description = "(Mandatory) Unique 3 digit number in yandex cloud for vm"
  validation {
    condition     = length(var.yc_postfix) == 3 && can(regex("[0-9]", var.yc_postfix))
    error_message = "Not valid value for postfix. Need 3 digits"

  }
}

variable "owner" {
  type        = string
  description = "(Optional) Owner tag for instance."

}

variable "domain_name" {
  type        = string
  description = "Private domain name for vm"
  default     = "pt.met"

}

variable "vm_vcpu_type" {
  type    = string
  default = "standard-v2"
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
  description = "(Required) CPU cores for the instance."
}


variable "vm_ram_qty" {
  type        = number
  default     = 2
  description = "(Required) Memory size in GB."
}


variable "service_account_id" {
  type        = string
  default     = null
  description = "(Optional) ID of the service account authorized for this instance."
}

variable "yc_metadata_options" {
  type        = any
  default     = {}
  description = "(Optional) Options allow user to configure access to instance's metadata"
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

variable "yc_create" {
  type        = bool
  default     = null
  description = "Create vm in yandex cloud"
}

variable "aws_create" {
  type        = bool
  default     = null
  description = "Create vm in yandex cloud"
}


variable "group" {
  type        = string
  default     = "application"
  description = "(Optional) Which group of host is it?"
}

variable "timeout" {
  type        = string
  default     = "15m"
  description = "(Optional) Timeouts for creation, deletion and update."

}

variable "cloud-init" {
  type        = string
  description = "(Required) Cloud init config script."
}

variable "additional_labels" {
  type        = map(any)
  description = "(Optional) Additional labels for servers."
  default     = {}

}