# Invalid variable value tests.
# expect_failures targets var.* — works because var_wrapper.tf has no resource
# graph, so OpenTofu evaluates variable validation blocks before anything else.
# This is confirmed to work in OpenTofu >= 1.8 with the native test framework.

run "ecs_network_mode_invalid" {
  command = plan
  variables { ecs_network_mode = "invalid" }
  expect_failures = [var.ecs_network_mode]
}

run "ecs_ipc_mode_invalid" {
  command = plan
  variables { ecs_ipc_mode = "shared" }
  expect_failures = [var.ecs_ipc_mode]
}

run "ecs_pid_mode_invalid" {
  command = plan
  variables { ecs_pid_mode = "container" }
  expect_failures = [var.ecs_pid_mode]
}

run "ecs_requires_compatibilities_invalid" {
  command = plan
  variables { ecs_requires_compatibilities = ["FARGATE", "LAMBDA"] }
  expect_failures = [var.ecs_requires_compatibilities]
}

run "ecs_cpu_invalid" {
  command = plan
  variables { ecs_cpu = 300 }
  expect_failures = [var.ecs_cpu]
}

run "ecs_ephemeral_storage_too_small" {
  command = plan
  variables { ecs_ephemeral_storage = [{ size_in_gib = 10 }] }
  expect_failures = [var.ecs_ephemeral_storage]
}

run "ecs_ephemeral_storage_too_large" {
  command = plan
  variables { ecs_ephemeral_storage = [{ size_in_gib = 201 }] }
  expect_failures = [var.ecs_ephemeral_storage]
}

run "ecs_placement_constraints_invalid" {
  command = plan
  variables { ecs_placement_constraints = [{ type = "random" }] }
  expect_failures = [var.ecs_placement_constraints]
}

run "ecs_settings_invalid_name" {
  command = plan
  variables { ecs_settings = [{ name = "unknownSetting", value = "enabled" }] }
  expect_failures = [var.ecs_settings]
}

run "ecs_settings_invalid_value" {
  command = plan
  variables { ecs_settings = [{ name = "containerInsights", value = "yes" }] }
  expect_failures = [var.ecs_settings]
}

run "ecs_configurations_invalid_logging" {
  command = plan
  variables { ecs_configurations = [{ execute_command_configuration = [{ logging = "ALL" }] }] }
  expect_failures = [var.ecs_configurations]
}

run "network_acceleration_type_invalid" {
  command = plan
  variables { network_acceleration_type = "hardware_accelerated" }
  expect_failures = [var.network_acceleration_type]
}

run "serverless_metadata_options_invalid" {
  command = plan
  variables { serverless_metadata_options = { aws_v1_http_endpoint = 5, gce_http_endpoint = 0 } }
  expect_failures = [var.serverless_metadata_options]
}

run "serverless_runtime_invalid" {
  command = plan
  variables { serverless_runtime = { type = "grpc" } }
  expect_failures = [var.serverless_runtime]
}

run "serverless_secrets_invalid_env_var" {
  command = plan
  variables { serverless_secrets = { environment_variable = "1_INVALID", id = "sid", key = "skey" } }
  expect_failures = [var.serverless_secrets]
}

run "serverless_mounts_invalid_mode" {
  command = plan
  variables { serverless_mounts = { mode = "write" } }
  expect_failures = [var.serverless_mounts]
}
