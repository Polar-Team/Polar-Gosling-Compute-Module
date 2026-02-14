run "test_aws_vm_creation" {
  command = apply

  assert {
    condition     = module.aws_test_vm.id != ""
    error_message = "AWS VM ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.aws_test_vm.hostname))
    error_message = "Hostname should contain 'gosling'"
  }

  assert {
    condition     = can(regex("^10\\.1\\.0\\.", module.aws_test_vm.private_ip)) != ""
    error_message = "Private IP should fit test subnet scope 10.1.0.x"
  }

  assert {
    condition     = module.aws_test_vm.public_ip != ""
    error_message = "Public IP should not be empty"
  }
}
