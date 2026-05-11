#################################################
#                                               #
#           Labels (injected by root)           #
#                                               #
#################################################

variable "labels" {
  description = "Map of labels computed at the root module and merged into YC resource labels"
  type        = map(string)
  default     = {}
}

#################################################
#                                               #
#           Shared YC metadata inputs           #
#                                               #
#################################################

variable "cloud-init" {
  nullable    = true
  default     = null
  type        = string
  description = "Cloud-init user data (YAML/shell). Passed to the YC VM as `user-data` metadata."
}

variable "vault-token" {
  type        = string
  default     = null
  sensitive   = true
  description = "Temporary HashiCorp Vault token injected into YC VM metadata."
}

variable "service_account_id" {
  type        = string
  default     = null
  description = "YC service account assigned to the VM or serverless container."
}

variable "timeout" {
  type        = string
  default     = "15m"
  description = "Maximum duration for create/update/delete operations."
}

#################################################
#                                               #
#               YC VM variables                 #
#                                               #
#################################################

variable "source_image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "source_image_id" {
  type    = string
  default = null
}

variable "yc_vm_create" {
  type    = bool
  default = false
}

variable "creation_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "yc_prefix" {
  type    = string
  default = "gosling-runner"
}

variable "vm_vcpu_type" {
  type    = string
  default = "standard-v2"
}

variable "core_fraction" {
  type    = number
  default = null
}

variable "allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "network_acceleration_type" {
  type    = string
  default = "standard"
  validation {
    condition     = var.network_acceleration_type == "standard" || var.network_acceleration_type == "software_accelerated"
    error_message = "Only two possible values could be inputed - standard, software_accelerated"
  }
}

variable "vm_vcpu_qty" {
  type    = number
  default = 2
}

variable "vm_ram_qty" {
  type    = number
  default = 2
}

variable "metadata_options" {
  type    = any
  default = {}
}

variable "placement_policy" {
  type    = list(any)
  default = []
}

variable "scheduling_policy" {
  type    = any
  default = {}
}

variable "boot_disk" {
  type    = any
  default = {}
}

variable "secondary_disk" {
  type    = list(any)
  default = []
}

variable "local_disk" {
  type    = list(any)
  default = []
}

variable "filesystem" {
  type    = list(any)
  default = []
}

variable "yc_network_interface" {
  type    = any
  default = {}
}

#################################################
#                                               #
#           YC Serverless variables             #
#                                               #
#################################################

variable "yc_serverless_create" {
  type    = bool
  default = false
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
}

variable "serverless_connectivity" {
  type    = map(any)
  default = {}
}

variable "serverless_log_options" {
  type    = map(any)
  default = {}
}

variable "serverless_metadata_options" {
  type    = map(any)
  default = {}
  validation {
    condition = (
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "aws_v1_http_endpoint", 0)) &&
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "gce_http_endpoint", 0))
    ) || var.serverless_metadata_options == {}
    error_message = "Only three possible values could be inputed for aws_v1_http_endpoint and gce_http_endpoint - 0, 1, 2"
  }
}

variable "serverless_mounts" {
  type    = map(any)
  default = {}
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
  type    = map(any)
  default = {}
}

variable "serverless_runtime" {
  type    = map(any)
  default = {}
  validation {
    condition = (
      try(var.serverless_runtime["type"], "http") == "http" ||
      try(var.serverless_runtime["type"], "http") == "task"
    ) || var.serverless_runtime == {}
    error_message = "Only two possible values could be inputed for type - http, task"
  }
}

variable "serverless_secrets" {
  type    = map(any)
  default = {}
  validation {
    condition = (
      length(regexall("^[A-Za-z]", try(var.serverless_secrets["environment_variable"], "A"))) > 0
    ) || var.serverless_secrets == {}
    error_message = "Environment variable must begin with a letter (A-Z,a-z)."
  }
}

variable "serverless_async_invocation" {
  type    = map(any)
  default = {}
}

variable "serverless_description" {
  type    = string
  default = null
}

variable "serverless_memory" {
  type    = number
  default = 128
}

variable "serverless_cores" {
  type    = number
  default = null
}

variable "serverless_concurrency" {
  type    = number
  default = null
}

variable "serverless_core_fraction" {
  type    = number
  default = null
}

variable "serverless_execution_timeout" {
  type    = string
  default = null
}
