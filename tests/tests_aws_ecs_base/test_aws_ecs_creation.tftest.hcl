run "test_aws_ecs_creation" {
  command = apply

  assert {
    condition     = module.aws_test_ecs.id != ""
    error_message = "AWS ECS Task Definition ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.aws_test_ecs.hostname))
    error_message = "Hostname should contain 'gosling'"
  }
}
