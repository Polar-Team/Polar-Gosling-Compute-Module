# AWS Compute Module

Terraform/OpenTofu submodule for provisioning AWS compute resources (EC2 instances and ECS Fargate tasks).

## Usage

```hcl
module "aws_vm" {
  source = "git::https://github.com/Polar-Team/Polar-Gosling-Compute-Module.git//modules/aws"

  aws_vm_create = true
  aws_prefix    = "my-app"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0123456789abcdef0"

  vpc_security_group_ids = ["sg-0123456789abcdef0"]

  tags = {
    Environment = "dev"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.5 |
| aws | >= 4.66 |
| random | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.66 |
| random | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| labels | Map of labels/tags computed at the root module and merged into AWS resource tags | `map(string)` | `{}` | no |
| ami\_ssm\_parameter | SSM parameter name for the AMI ID | `string` | `"/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"` | no |
| aws\_vm\_create | Whether to create an EC2 instance | `bool` | `false` | no |
| aws\_prefix | Naming prefix appended to all AWS resource names and tags | `string` | `"gosling-runner"` | no |
| ami | ID of AMI to use for the instance. If null, resolved via the SSM parameter | `string` | `null` | no |
| associate\_public\_ip\_address | n/a | `bool` | `null` | no |
| maintenance\_options | n/a | `any` | `{}` | no |
| availability\_zone | n/a | `string` | `null` | no |
| capacity\_reservation\_specification | n/a | `any` | `{}` | no |
| cpu\_credits | n/a | `string` | `null` | no |
| disable\_api\_termination | n/a | `bool` | `null` | no |
| ebs\_block\_device | n/a | `list(any)` | `[]` | no |
| ebs\_optimized | n/a | `bool` | `null` | no |
| enclave\_options\_enabled | n/a | `bool` | `null` | no |
| ephemeral\_block\_device | n/a | `list(map(string))` | `[]` | no |
| get\_password\_data | n/a | `bool` | `null` | no |
| hibernation | n/a | `bool` | `null` | no |
| host\_id | n/a | `string` | `null` | no |
| iam\_instance\_profile | n/a | `string` | `null` | no |
| instance\_initiated\_shutdown\_behavior | n/a | `string` | `null` | no |
| instance\_type | n/a | `string` | `"t3.micro"` | no |
| instance\_tags | n/a | `map(string)` | `{}` | no |
| ipv6\_address\_count | n/a | `number` | `null` | no |
| ipv6\_addresses | n/a | `list(string)` | `null` | no |
| key\_name | n/a | `string` | `null` | no |
| launch\_template | n/a | `map(string)` | `{}` | no |
| aws\_metadata\_options | n/a | `map(string)` | see below | no |
| monitoring | n/a | `bool` | `null` | no |
| aws\_network\_interface | n/a | `list(map(string))` | `[]` | no |
| private\_dns\_name\_options | n/a | `map(string)` | `{}` | no |
| placement\_group | n/a | `string` | `null` | no |
| private\_ip | n/a | `string` | `null` | no |
| root\_block\_device | n/a | `list(any)` | `[]` | no |
| secondary\_private\_ips | n/a | `list(string)` | `null` | no |
| source\_dest\_check | n/a | `bool` | `null` | no |
| subnet\_id | n/a | `string` | `null` | no |
| tags | n/a | `map(string)` | `{}` | no |
| tenancy | n/a | `string` | `null` | no |
| user\_data | n/a | `string` | `null` | no |
| user\_data\_base64 | n/a | `string` | `null` | no |
| user\_data\_replace\_on\_change | n/a | `bool` | `null` | no |
| volume\_tags | n/a | `map(string)` | `{}` | no |
| enable\_volume\_tags | n/a | `bool` | `true` | no |
| vpc\_security\_group\_ids | n/a | `list(string)` | `null` | no |
| timeouts | n/a | `map(string)` | `{}` | no |
| cpu\_options | n/a | `any` | `{}` | no |
| disable\_api\_stop | n/a | `bool` | `null` | no |
| ecs\_settings | n/a | `list(object({name=string, value=string}))` | `[]` | no |
| ecs\_configurations | n/a | `list(object({...}))` | `[]` | no |
| ecs\_service\_connect\_defaults | n/a | `list(object({namespace=string}))` | `[]` | no |
| aws\_ecs\_create | n/a | `bool` | `false` | no |
| ecs\_network\_mode | n/a | `string` | `"awsvpc"` | no |
| ecs\_ipc\_mode | n/a | `string` | `null` | no |
| ecs\_pid\_mode | n/a | `string` | `null` | no |
| ecs\_enable\_fault\_injection | n/a | `bool` | `false` | no |
| ecs\_skip\_destroy | n/a | `bool` | `false` | no |
| ecs\_requires\_compatibilities | n/a | `list(string)` | `["FARGATE"]` | no |
| ecs\_cpu | n/a | `number` | `256` | no |
| ecs\_memory | n/a | `number` | `512` | no |
| ecs\_execution\_role\_arn | n/a | `string` | `null` | no |
| ecs\_task\_role\_arn | n/a | `string` | `null` | no |
| ecs\_tags | n/a | `map(string)` | `{}` | no |
| ecs\_track\_latest | n/a | `bool` | `false` | no |
| ecs\_volumes | n/a | `list(object({...}))` | `[]` | no |
| ecs\_runtime\_platform | n/a | `list(object({...}))` | `[]` | no |
| ecs\_placement\_constraints | n/a | `list(object({type=string, expression=optional(string)}))` | `[]` | no |
| ecs\_proxy\_configuration | n/a | `list(object({...}))` | `[]` | no |
| ecs\_ephemeral\_storage | n/a | `list(object({size_in_gib=number}))` | `[]` | no |
| container\_name | n/a | `string` | `null` | no |
| container\_image | n/a | `string` | `null` | no |
| container\_cpu | n/a | `number` | `null` | no |
| container\_memory | n/a | `number` | `null` | no |
| container\_essential | n/a | `bool` | `null` | no |
| container\_memory\_reservation | n/a | `number` | `null` | no |
| container\_portmappings | n/a | `list(object({...}))` | `null` | no |
| container\_environment | n/a | `list(object({name=string, value=string}))` | `null` | no |
| container\_environment\_files | n/a | `list(object({value=string, type=string}))` | `null` | no |
| container\_secrets | n/a | `list(object({name=string, valueFrom=string}))` | `null` | no |
| container\_depends\_on | n/a | `list(object({containerName=string, condition=string}))` | `null` | no |
| container\_links | n/a | `list(string)` | `null` | no |
| container\_volumes\_from | n/a | `list(object({sourceContainer=string, readOnly=optional(bool)}))` | `null` | no |
| container\_mount\_points | n/a | `list(object({sourceVolume=string, containerPath=string, readOnly=optional(bool)}))` | `null` | no |
| container\_linux\_parameters | n/a | `object({...})` | `null` | no |
| container\_hostname | n/a | `string` | `null` | no |
| container\_user | n/a | `string` | `null` | no |
| container\_working\_directory | n/a | `string` | `null` | no |
| container\_disable\_networking | n/a | `bool` | `null` | no |
| container\_privileged | n/a | `bool` | `null` | no |
| container\_readonly\_root\_filesystem | n/a | `bool` | `null` | no |
| container\_dns\_servers | n/a | `list(string)` | `null` | no |
| container\_dns\_search\_domains | n/a | `list(string)` | `null` | no |
| container\_extra\_hosts | n/a | `list(object({hostname=string, ipAddress=string}))` | `null` | no |
| container\_docker\_security\_options | n/a | `list(string)` | `null` | no |
| container\_docker\_labels | n/a | `map(string)` | `null` | no |
| container\_ulimits | n/a | `list(object({name=string, softLimit=number, hardLimit=number}))` | `null` | no |
| container\_command | n/a | `list(string)` | `null` | no |
| container\_entry\_point | n/a | `list(string)` | `null` | no |
| container\_health\_check | n/a | `object({command=list(string), interval=optional(number), timeout=optional(number), retries=optional(number), startPeriod=optional(number)})` | `null` | no |
| container\_start\_timeout | n/a | `number` | `null` | no |
| container\_stop\_timeout | n/a | `number` | `null` | no |
| container\_system\_controls | n/a | `list(object({namespace=string, value=string}))` | `null` | no |
| container\_resource\_requirements | n/a | `list(object({type=string, value=string}))` | `null` | no |
| container\_firelens\_configuration | n/a | `object({type=string, options=optional(map(string))})` | `null` | no |
| container\_interactive | n/a | `bool` | `null` | no |
| container\_pseudo\_terminal | n/a | `bool` | `null` | no |
| awslogs\_group | n/a | `string` | `"/aws/ecs/default"` | no |
| awslogs\_stream\_prefix | n/a | `string` | `"ecs"` | no |
| aws\_region | n/a | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Hostname/Name tag for the created AWS resource. Empty string if nothing was created. |
| public\_ip | Public IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created. |
| private\_ip | Private IP of the EC2 instance; 'serverless' for ECS; empty string when nothing was created. |
| id | ID of the created AWS resource (EC2 instance ID or ECS task definition ID). |
