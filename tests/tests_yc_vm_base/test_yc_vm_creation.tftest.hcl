run "test_yc_vm_creation" {
  command = apply

  assert {
    condition     = module.yc_test_vm.id != ""
    error_message = "YC VM ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.yc_test_vm.hostname))
    error_message = "Hostname should contain 'gosling'"
  }

  assert {
    condition     = can(regex("^10\\.2\\.", module.yc_test_vm.private_ip[0]))
    error_message = "Private IP should be in the 10.2.x.x range"
  }

  assert {
    condition     = length(module.yc_test_vm.public_ip) > 0
    error_message = "Public IP list should not be empty"
  }

  assert {
    condition     = length(module.yc_test_vm.id) > 10
    error_message = "YC VM ID should be a valid long identifier"
  }

  assert {
    condition     = length(module.yc_test_vm.private_ip) > 0
    error_message = "Private IP list should not be empty"
  }

  assert {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$", module.yc_test_vm.public_ip[0]))
    error_message = "Public IP should be a valid IPv4 address"
  }
}
