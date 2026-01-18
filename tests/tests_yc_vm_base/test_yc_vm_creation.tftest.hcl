run "test_yc_vm_creation" {
  command = apply

  assert {
    condition     = module.yc_test_vm.vm_id != ""
    error_message = "YC VM ID should not be empty"
  }

  assert {
    condition     = can(regex("gosling", module.yc_test_vm.vm_hostname))
    error_message = "Hostname should contain 'gosling'"
  }

  assert {
    condition     = can(regex("^10\\.2\\.", module.yc_test_vm.vm_private_ip[0]))
    error_message = "Private IP should be in the 10.2.x.x range"
  }

  assert {
    condition     = module.yc_test_vm.vm_public_ip != ""
    error_message = "Public IP should not be empty"
  }
}
