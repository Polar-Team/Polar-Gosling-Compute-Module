locals {

  labels = merge({
    created_at = formatdate("DD-MM-YYYY-hh-mm", timestamp()),
    owner      = var.owner
    group      = var.group
    },
  var.additional_labels)

  ami = try(coalesce(var.ami, try(nonsensitive(data.aws_ssm_parameter.this[0].value), null)), null)

  ######## Generating Outputs #########

  hostname = (var.yc_create ? [
    for s in yandex_compute_instance.this : s.hostname
    ].0 :
    [
      for s in aws_instance.this : s.private_dns
    ].0
  )

  public_ip = (var.yc_create ? [
    for s in yandex_compute_instance.this : s.network_interface[*].nat_ip_address
    ].0 :
    [
      for s in aws_instance.this : s.public_ip
    ].0
  )

  private_ip = (var.yc_create ? [
    for s in yandex_compute_instance.this : s.network_interface[*].ip_address
    ].0 :
    [
      for s in aws_instance.this : s.private_ip
    ]
  )

}








