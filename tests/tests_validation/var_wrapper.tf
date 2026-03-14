terraform {
  required_version = ">= 1.3.5"
}

# ---------------------------------------------------------------------------
# Variables with validation — mirrors the main module exactly
# ---------------------------------------------------------------------------

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

variable "ecs_ephemeral_storage" {
  type    = list(object({ size_in_gib = number }))
  default = []
  validation {
    condition     = alltrue([for s in var.ecs_ephemeral_storage : s.size_in_gib >= 21 && s.size_in_gib <= 200])
    error_message = "Ephemeral storage size must be between 21 GiB and 200 GiB."
  }
}

variable "ecs_placement_constraints" {
  type    = list(object({ type = string, expression = optional(string) }))
  default = []
  validation {
    condition     = alltrue([for c in var.ecs_placement_constraints : contains(["memberOf", "distinctInstance"], c.type)])
    error_message = "Placement constraint type must be one of: memberOf, distinctInstance."
  }
}

variable "ecs_settings" {
  type    = list(object({ name = string, value = string }))
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
    execute_command_configuration = optional(list(object({ logging = optional(string), kms_key_id = optional(string) })))
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

variable "network_acceleration_type" {
  type    = string
  default = "standard"
  validation {
    condition     = contains(["standard", "software_accelerated"], var.network_acceleration_type)
    error_message = "Only two possible values: standard, software_accelerated."
  }
}

variable "serverless_metadata_options" {
  type    = map(any)
  default = {}
  validation {
    condition = (
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "aws_v1_http_endpoint", 0)) &&
      contains([0, 1, 2], lookup(var.serverless_metadata_options, "gce_http_endpoint", 0))
    ) || var.serverless_metadata_options == {}
    error_message = "aws_v1_http_endpoint and gce_http_endpoint must be 0, 1, or 2."
  }
}

variable "serverless_runtime" {
  type    = map(any)
  default = {}
  validation {
    condition     = contains(["http", "task"], try(var.serverless_runtime["type"], "http"))
    error_message = "serverless_runtime type must be http or task."
  }
}

variable "serverless_secrets" {
  type    = map(any)
  default = {}
  validation {
    condition     = (length(regexall("^[A-Za-z]", try(var.serverless_secrets["environment_variable"], "A"))) > 0) || var.serverless_secrets == {}
    error_message = "Environment variable must begin with a letter (A-Z,a-z)."
  }
}

variable "serverless_mounts" {
  type    = map(any)
  default = {}
  validation {
    condition = (
      (length(try(var.serverless_mounts["ephemeral_disk"], [])) <= 1 &&
      length(try(var.serverless_mounts["object_storage"], [])) <= 1) &&
      contains(["ro", "rw"], try(var.serverless_mounts["mode"], "rw"))
    ) || var.serverless_mounts == {}
    error_message = "Mount mode must be ro or rw; only one of ephemeral_disk or object_storage allowed."
  }
}

# ---------------------------------------------------------------------------
# Outputs — expose vars so assertions can read them
# ---------------------------------------------------------------------------

output "ecs_network_mode" { value = var.ecs_network_mode }
output "ecs_ipc_mode" { value = var.ecs_ipc_mode }
output "ecs_pid_mode" { value = var.ecs_pid_mode }
output "ecs_requires_compatibilities" { value = var.ecs_requires_compatibilities }
output "ecs_cpu" { value = var.ecs_cpu }
output "ecs_ephemeral_storage" { value = var.ecs_ephemeral_storage }
output "ecs_placement_constraints" { value = var.ecs_placement_constraints }
output "ecs_settings" { value = var.ecs_settings }
output "ecs_configurations" { value = var.ecs_configurations }
output "network_acceleration_type" { value = var.network_acceleration_type }
output "serverless_metadata_options" { value = var.serverless_metadata_options }
output "serverless_runtime" { value = var.serverless_runtime }
output "serverless_secrets" { value = var.serverless_secrets }
output "serverless_mounts" { value = var.serverless_mounts }
