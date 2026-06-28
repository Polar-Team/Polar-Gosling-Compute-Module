data "aws_ssm_parameter" "this" {
  count = var.aws_vm_create ? 1 : 0
  name  = var.ami_ssm_parameter
}
