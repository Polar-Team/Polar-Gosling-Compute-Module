output "hostname" {
  description = "Hostname/Name tag for the created AWS resource. Empty string if nothing was created."
  value = (
    var.aws_vm_create ?
    try([for s in aws_instance.this : lookup(s.tags, "Name", "noname")][0], "") :
    var.aws_ecs_create ?
    try([for s in aws_ecs_task_definition.this : lookup(s.tags, "Name", "noname")][0], "") :
    ""
  )
}

output "public_ip" {
  description = "Public IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created."
  value = (
    var.aws_vm_create ?
    try([for s in aws_instance.this : s.public_ip][0], "") :
    var.aws_ecs_create ? "serverless" : ""
  )
}

output "private_ip" {
  description = "Private IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created."
  value = (
    var.aws_vm_create ?
    try([for s in aws_instance.this : s.private_ip][0], "") :
    var.aws_ecs_create ? "serverless" : ""
  )
}

output "id" {
  description = "ID of the created AWS resource (EC2 instance ID or ECS task definition ID)."
  value = (
    var.aws_vm_create ?
    try([for s in aws_instance.this : s.id][0], "") :
    var.aws_ecs_create ?
    try([for s in aws_ecs_task_definition.this : s.id][0], "") :
    ""
  )
}
