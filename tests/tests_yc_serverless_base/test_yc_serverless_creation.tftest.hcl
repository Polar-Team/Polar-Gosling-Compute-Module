run "test_yc_serverless_creation" {
  command = apply

  assert {
    condition     = module.yc_test_serverless.id != ""
    error_message = "YC Serverless Function ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.yc_test_serverless.hostname))
    error_message = "Hostname should contain 'gosling'"
  }

}
