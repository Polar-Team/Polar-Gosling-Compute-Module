output "hostname" {
  description = "Hostname/Name tag for the created AWS resource. Empty string if nothing was created."
  value = (
    var.aws_vm_create
    ? aws_instance.this[0].tags["Name"]
    : var.aws_ecs_create
      ? aws_ecs_task_definition.this[0].tags["Name"]
      : ""
  )
}

output "public_ip" {
  description = "Public IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created."
  value = (
    var.aws_vm_create
    ? aws_instance.this[0].public_ip
    : var.aws_ecs_create
      ? "serverless"
      : ""
  )
}

output "private_ip" {
  description = "Private IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created."
  value = (
    var.aws_vm_create
    ? aws_instance.this[0].private_ip
    : var.aws_ecs_create
      ? "serverless"
      : ""
  )
}

output "id" {
  description = "ID of the created AWS resource (EC2 instance ID or ECS task definition ID)."
  value = (
    var.aws_vm_create
    ? aws_instance.this[0].id
    : var.aws_ecs_create
      ? aws_ecs_task_definition.this[0].id
      : ""
  )
}
