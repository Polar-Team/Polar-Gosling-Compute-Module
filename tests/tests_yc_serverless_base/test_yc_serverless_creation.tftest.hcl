run "test_yc_serverless_creation" {
  command = apply

  assert {
    condition     = module.yc_test_serverless.id != ""
    error_message = "YC Serverless Container ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.yc_test_serverless.hostname))
    error_message = "Hostname should contain 'gosling'"
  }

  assert {
    condition     = module.yc_test_serverless.public_ip == "serverless"
    error_message = "Serverless public_ip should return 'serverless' since it is not a VM"
  }

  assert {
    condition     = module.yc_test_serverless.private_ip == "serverless"
    error_message = "Serverless private_ip should return 'serverless' since it is not a VM"
  }

  assert {
    condition     = length(module.yc_test_serverless.id) > 10
    error_message = "YC Serverless Container ID should be a valid long identifier"
  }
}
