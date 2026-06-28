# Yandex Cloud Compute Module

Terraform/OpenTofu submodule for provisioning Yandex Cloud compute resources (VM instances and serverless containers).

## Usage

```hcl
module "yc_vm" {
  source = "git::https://github.com/Polar-Team/Polar-Gosling-Compute-Module.git//modules/yc"

  yc_vm_create = true
  yc_prefix    = "my-app"
  vm_vcpu_qty  = 2
  vm_ram_qty   = 4

  yc_network_interface = {
    "0" = {
      subnet_id = "e9b0123456789abcdef0"
      nat       = true
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.5 |
| yandex | >= 0.170.0 |
| random | >= 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| yandex | >= 0.170.0 |
| random | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [yandex_serverless_container.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_container) | resource |
| [yandex_compute_instance.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |
| [yandex_compute_image.image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| labels | Map of labels computed at the root module and merged into YC resource labels | `map(string)` | `{}` | no |
| cloud-init | Cloud-init user data (YAML/shell). Passed to the YC VM as `user-data` metadata. | `string` | `null` | no |
| vault-token | Temporary HashiCorp Vault token injected into YC VM metadata. | `string` | `null` | no |
| service\_account\_id | YC service account assigned to the VM or serverless container. | `string` | `null` | no |
| timeout | Maximum duration for create/update/delete operations. | `string` | `"15m"` | no |
| source\_image\_family | n/a | `string` | `"ubuntu-2004-lts"` | no |
| source\_image\_id | n/a | `string` | `null` | no |
| yc\_vm\_create | n/a | `bool` | `false` | no |
| creation\_zone | n/a | `string` | `"ru-central1-a"` | no |
| yc\_prefix | n/a | `string` | `"gosling-runner"` | no |
| vm\_vcpu\_type | n/a | `string` | `"standard-v2"` | no |
| core\_fraction | n/a | `number` | `null` | no |
| allow\_stopping\_for\_update | n/a | `bool` | `true` | no |
| network\_acceleration\_type | n/a | `string` | `"standard"` | no |
| vm\_vcpu\_qty | n/a | `number` | `2` | no |
| vm\_ram\_qty | n/a | `number` | `2` | no |
| metadata\_options | n/a | `any` | `{}` | no |
| placement\_policy | n/a | `list(any)` | `[]` | no |
| scheduling\_policy | n/a | `any` | `{}` | no |
| boot\_disk | n/a | `any` | `{}` | no |
| secondary\_disk | n/a | `list(any)` | `[]` | no |
| local\_disk | n/a | `list(any)` | `[]` | no |
| filesystem | n/a | `list(any)` | `[]` | no |
| yc\_network\_interface | n/a | `any` | `{}` | no |
| yc\_serverless\_create | n/a | `bool` | `false` | no |
| serverless\_image | n/a | `object({url=string, args=optional(list(string)), command=optional(list(string)), digest=optional(string), environment=optional(map(string)), work_dir=optional(string)})` | `{url="dummy"}` | no |
| serverless\_connectivity | n/a | `map(any)` | `{}` | no |
| serverless\_log\_options | n/a | `map(any)` | `{}` | no |
| serverless\_metadata\_options | n/a | `map(any)` | `{}` | no |
| serverless\_mounts | n/a | `map(any)` | `{}` | no |
| serverless\_provision\_policy | n/a | `map(any)` | `{}` | no |
| serverless\_runtime | n/a | `map(any)` | `{}` | no |
| serverless\_secrets | n/a | `map(any)` | `{}` | no |
| serverless\_async\_invocation | n/a | `map(any)` | `{}` | no |
| serverless\_description | n/a | `string` | `null` | no |
| serverless\_memory | n/a | `number` | `128` | no |
| serverless\_cores | n/a | `number` | `null` | no |
| serverless\_concurrency | n/a | `number` | `null` | no |
| serverless\_core\_fraction | n/a | `number` | `null` | no |
| serverless\_execution\_timeout | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| hostname | Hostname for the YC compute instance or container name for serverless. Empty string if nothing was created. |
| public\_ip | NAT IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created. |
| private\_ip | Private IP of the YC compute instance's first network interface; 'serverless' for serverless containers; empty string when nothing was created. |
| id | ID of the created YC resource (compute instance ID or serverless container ID). |
