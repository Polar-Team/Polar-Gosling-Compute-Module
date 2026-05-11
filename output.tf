output "hostname" {
  description = "The hostname or name of the created resource. For VMs this is the instance hostname (contains the prefix and random suffix); for ECS/serverless it is the resource Name tag or container name"
  value       = try(module.aws[0].hostname, module.yc[0].hostname, "")
}

output "public_ip" {
  description = "The public IP address of the created resource. For AWS EC2 this is the instance public IP; for YC VM it is the NAT IP from the first network interface; returns `\"serverless\"` for non-VM resources"
  value       = try(module.aws[0].public_ip, module.yc[0].public_ip, "")
}

output "private_ip" {
  description = "The private IP address of the created resource. For AWS EC2 this is the instance private IP; for YC VM it is the internal IP from the first network interface; returns `\"serverless\"` for non-VM resources"
  value       = try(module.aws[0].private_ip, module.yc[0].private_ip, "")
}

output "id" {
  description = "The unique identifier of the created resource. For AWS EC2 this is the instance ID (i-xxx); for YC VM it is the compute instance ID; for ECS it is the task definition ID; for YC serverless it is the container ID"
  value       = try(module.aws[0].id, module.yc[0].id, "")
}
