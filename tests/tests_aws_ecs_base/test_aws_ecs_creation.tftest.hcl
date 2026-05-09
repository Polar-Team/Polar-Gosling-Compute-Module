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

  assert {
    condition     = module.aws_test_ecs.public_ip == "serverless"
    error_message = "ECS public_ip should return 'serverless' since it is not a VM"
  }

  assert {
    condition     = module.aws_test_ecs.private_ip == "serverless"
    error_message = "ECS private_ip should return 'serverless' since it is not a VM"
  }

  assert {
    condition     = can(regex("^arn:aws:ecs:", module.aws_test_ecs.id)) || length(module.aws_test_ecs.id) > 0
    error_message = "ECS task definition ID should be a valid ARN or non-empty identifier"
  }
}
