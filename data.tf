##################################################
#                                                #
#              YC provider data                  #
#                                                #
##################################################

data "yandex_client_config" "client" {

  count = local.yc_create_sum ? 1 : 0
}

data "yandex_compute_image" "image" {

  count = var.yc_vm_create ? 1 : 0

  image_id = var.source_image_id
  family   = var.source_image_family

}

##################################################
#                                                #
#              AWS VM provider data              #
#                                                #
##################################################

# data "aws_partition" "current" {
#   count = var.aws_vm_create ? 1 : 0
# }

data "aws_ssm_parameter" "this" {
  count = var.aws_vm_create ? 1 : 0

  name = var.ami_ssm_parameter
}

