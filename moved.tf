##################################################
#                                                #
#   State migration for the provider split       #
#                                                #
#   These `moved` blocks preserve existing state #
#   when upgrading from the flat-root layout to  #
#   the per-cloud submodule layout. They are     #
#   no-ops when the target resources do not yet  #
#   exist (e.g. first apply or wrong cloud).     #
#                                                #
##################################################

# --- AWS ---
moved {
  from = random_string.aws-this
  to   = module.aws[0].random_string.this
}

moved {
  from = aws_instance.this
  to   = module.aws[0].aws_instance.this
}

moved {
  from = aws_ecs_cluster.this
  to   = module.aws[0].aws_ecs_cluster.this
}

moved {
  from = aws_ecs_task_definition.this
  to   = module.aws[0].aws_ecs_task_definition.this
}

moved {
  from = data.aws_ssm_parameter.this
  to   = module.aws[0].data.aws_ssm_parameter.this
}

# --- YC ---
moved {
  from = random_string.yc-this
  to   = module.yc[0].random_string.this
}

moved {
  from = yandex_compute_instance.this
  to   = module.yc[0].yandex_compute_instance.this
}

moved {
  from = yandex_serverless_container.this
  to   = module.yc[0].yandex_serverless_container.this
}

moved {
  from = data.yandex_client_config.client
  to   = module.yc[0].data.yandex_client_config.client
}

moved {
  from = data.yandex_compute_image.image
  to   = module.yc[0].data.yandex_compute_image.image
}
