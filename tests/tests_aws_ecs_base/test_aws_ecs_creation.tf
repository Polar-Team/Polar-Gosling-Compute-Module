module "aws_test_ecs" {
  source         = "../../"
  aws_ecs_create = true

  ecs_execution_role_arn = "arn:aws:iam::650215453600:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  ecs_task_role_arn      = "arn:aws:iam::650215453600:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"

  ecs_cpu    = 256
  ecs_memory = 512

  container_name   = "test-nginx-container"
  container_image  = "nginx:latest"
  container_cpu    = 256
  container_memory = 512

  container_portmappings = [
    {
      container_port = 80
      protocol       = "tcp"
    }
  ]

  container_environment = [
    {
      name  = "ENV_VAR_1"
      value = "value1"
    },
    {
      name  = "ENV_VAR_2"
      value = "value2"
    }
  ]

  awslogs_group         = "/aws/ecs/test-task"
  awslogs_stream_prefix = "ecs"
  aws_region            = "us-east-1"

  additional_labels = {
    environment = "test"
    purpose     = "opentofu-aws-ecs-test"
  }
}
