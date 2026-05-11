# Valid variable value tests.
# Uses the var_wrapper.tf which re-declares only validated variables with no
# resource graph — no providers or credentials needed.

run "ecs_network_mode_valid_awsvpc" {
  command = plan
  variables { ecs_network_mode = "awsvpc" }
  assert {
    condition     = var.ecs_network_mode == "awsvpc"
    error_message = "awsvpc should be accepted"
  }
}

run "ecs_network_mode_valid_bridge" {
  command = plan
  variables { ecs_network_mode = "bridge" }
  assert {
    condition     = var.ecs_network_mode == "bridge"
    error_message = "bridge should be accepted"
  }
}

run "ecs_ipc_mode_valid_host" {
  command = plan
  variables { ecs_ipc_mode = "host" }
  assert {
    condition     = var.ecs_ipc_mode == "host"
    error_message = "host should be accepted"
  }
}

run "ecs_ipc_mode_null_allowed" {
  command = plan
  variables { ecs_ipc_mode = null }
  assert {
    condition     = var.ecs_ipc_mode == null
    error_message = "null should be accepted"
  }
}

run "ecs_pid_mode_valid_task" {
  command = plan
  variables { ecs_pid_mode = "task" }
  assert {
    condition     = var.ecs_pid_mode == "task"
    error_message = "task should be accepted"
  }
}

run "ecs_requires_compatibilities_valid" {
  command = plan
  variables { ecs_requires_compatibilities = ["FARGATE", "EC2"] }
  assert {
    condition     = length(var.ecs_requires_compatibilities) == 2
    error_message = "FARGATE and EC2 should be accepted"
  }
}

run "ecs_cpu_valid_256" {
  command = plan
  variables { ecs_cpu = 256 }
  assert {
    condition     = var.ecs_cpu == 256
    error_message = "256 should be valid"
  }
}

run "ecs_cpu_valid_4096" {
  command = plan
  variables { ecs_cpu = 4096 }
  assert {
    condition     = var.ecs_cpu == 4096
    error_message = "4096 should be valid"
  }
}

run "ecs_ephemeral_storage_valid" {
  command = plan
  variables { ecs_ephemeral_storage = [{ size_in_gib = 50 }] }
  assert {
    condition     = var.ecs_ephemeral_storage[0].size_in_gib == 50
    error_message = "50 GiB should be valid"
  }
}

run "ecs_placement_constraints_valid" {
  command = plan
  variables { ecs_placement_constraints = [{ type = "memberOf", expression = "attribute:ecs.os-type == linux" }] }
  assert {
    condition     = var.ecs_placement_constraints[0].type == "memberOf"
    error_message = "memberOf should be valid"
  }
}

run "ecs_settings_valid" {
  command = plan
  variables { ecs_settings = [{ name = "containerInsights", value = "enabled" }] }
  assert {
    condition     = var.ecs_settings[0].value == "enabled"
    error_message = "enabled should be valid"
  }
}

run "ecs_configurations_valid_logging" {
  command = plan
  variables { ecs_configurations = [{ execute_command_configuration = [{ logging = "OVERRIDE" }] }] }
  assert {
    condition     = var.ecs_configurations[0].execute_command_configuration[0].logging == "OVERRIDE"
    error_message = "OVERRIDE should be valid"
  }
}

run "network_acceleration_type_valid_standard" {
  command = plan
  variables { network_acceleration_type = "standard" }
  assert {
    condition     = var.network_acceleration_type == "standard"
    error_message = "standard should be valid"
  }
}

run "network_acceleration_type_valid_software_accelerated" {
  command = plan
  variables { network_acceleration_type = "software_accelerated" }
  assert {
    condition     = var.network_acceleration_type == "software_accelerated"
    error_message = "software_accelerated should be valid"
  }
}

run "serverless_metadata_options_valid" {
  command = plan
  variables { serverless_metadata_options = { aws_v1_http_endpoint = 1, gce_http_endpoint = 2 } }
  assert {
    condition     = lookup(var.serverless_metadata_options, "aws_v1_http_endpoint", -1) == 1
    error_message = "Valid metadata options should be accepted"
  }
}

run "serverless_runtime_valid_http" {
  command = plan
  variables { serverless_runtime = { type = "http" } }
  assert {
    condition     = var.serverless_runtime["type"] == "http"
    error_message = "http should be valid"
  }
}

run "serverless_runtime_valid_task" {
  command = plan
  variables { serverless_runtime = { type = "task" } }
  assert {
    condition     = var.serverless_runtime["type"] == "task"
    error_message = "task should be valid"
  }
}

run "serverless_secrets_valid_env_var" {
  command = plan
  variables { serverless_secrets = { environment_variable = "MY_SECRET", id = "sid", key = "skey" } }
  assert {
    condition     = var.serverless_secrets["environment_variable"] == "MY_SECRET"
    error_message = "Env var starting with letter should be accepted"
  }
}

run "serverless_mounts_valid_mode_ro" {
  command = plan
  variables { serverless_mounts = { mode = "ro" } }
  assert {
    condition     = var.serverless_mounts["mode"] == "ro"
    error_message = "ro should be valid"
  }
}


# ---------------------------------------------------------------------------
# ECS service_connect_defaults — valid
# ---------------------------------------------------------------------------

run "ecs_service_connect_defaults_valid_single" {
  command = plan
  variables { ecs_service_connect_defaults = [{ namespace = "arn:aws:servicediscovery:us-east-1:123456789:namespace/ns-abc123" }] }
  assert {
    condition     = length(var.ecs_service_connect_defaults) == 1
    error_message = "A single service_connect_defaults entry should be accepted"
  }
}

run "ecs_service_connect_defaults_valid_empty" {
  command = plan
  variables { ecs_service_connect_defaults = [] }
  assert {
    condition     = length(var.ecs_service_connect_defaults) == 0
    error_message = "Empty list should be accepted"
  }
}

# ---------------------------------------------------------------------------
# ECS memory — valid
# ---------------------------------------------------------------------------

run "ecs_memory_valid_512" {
  command = plan
  variables { ecs_memory = 512 }
  assert {
    condition     = var.ecs_memory == 512
    error_message = "512 MiB should be valid"
  }
}

run "ecs_memory_valid_8192" {
  command = plan
  variables { ecs_memory = 8192 }
  assert {
    condition     = var.ecs_memory == 8192
    error_message = "8192 MiB should be valid"
  }
}

# ---------------------------------------------------------------------------
# Serverless memory — valid
# ---------------------------------------------------------------------------

run "serverless_memory_valid_128" {
  command = plan
  variables { serverless_memory = 128 }
  assert {
    condition     = var.serverless_memory == 128
    error_message = "128 MB should be valid"
  }
}

run "serverless_memory_valid_1024" {
  command = plan
  variables { serverless_memory = 1024 }
  assert {
    condition     = var.serverless_memory == 1024
    error_message = "1024 MB should be valid"
  }
}

# ---------------------------------------------------------------------------
# ECS network mode — additional valid values
# ---------------------------------------------------------------------------

run "ecs_network_mode_valid_none" {
  command = plan
  variables { ecs_network_mode = "none" }
  assert {
    condition     = var.ecs_network_mode == "none"
    error_message = "none should be accepted"
  }
}

run "ecs_network_mode_valid_host" {
  command = plan
  variables { ecs_network_mode = "host" }
  assert {
    condition     = var.ecs_network_mode == "host"
    error_message = "host should be accepted"
  }
}

# ---------------------------------------------------------------------------
# ECS requires_compatibilities — additional valid combinations
# ---------------------------------------------------------------------------

run "ecs_requires_compatibilities_valid_ec2_only" {
  command = plan
  variables { ecs_requires_compatibilities = ["EC2"] }
  assert {
    condition     = var.ecs_requires_compatibilities[0] == "EC2"
    error_message = "EC2 alone should be accepted"
  }
}

run "ecs_requires_compatibilities_valid_external" {
  command = plan
  variables { ecs_requires_compatibilities = ["EXTERNAL"] }
  assert {
    condition     = var.ecs_requires_compatibilities[0] == "EXTERNAL"
    error_message = "EXTERNAL alone should be accepted"
  }
}

# ---------------------------------------------------------------------------
# ECS placement constraints — additional valid case
# ---------------------------------------------------------------------------

run "ecs_placement_constraints_valid_distinct_instance" {
  command = plan
  variables { ecs_placement_constraints = [{ type = "distinctInstance" }] }
  assert {
    condition     = var.ecs_placement_constraints[0].type == "distinctInstance"
    error_message = "distinctInstance should be valid"
  }
}
