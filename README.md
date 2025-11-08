# Polar-Gosling-Compute-Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.66 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.100.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.92.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.127.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [random_string.aws-this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.yc-this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [yandex_compute_instance.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [yandex_compute_image.image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_labels"></a> [additional\_labels](#input\_additional\_labels) | (Optional) Additional labels for servers. | `map(any)` | `null` | no |
| <a name="input_allow_stopping_for_update"></a> [allow\_stopping\_for\_update](#input\_allow\_stopping\_for\_update) | (Optional) If true, allows Terraform to stop the instance in order to update its properties.<br/>If you try to update a property that requires stopping the instance without setting this field, the update will fail. | `bool` | `true` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | ID of AMI to use for the instance | `string` | `null` | no |
| <a name="input_ami_ssm_parameter"></a> [ami\_ssm\_parameter](#input\_ami\_ssm\_parameter) | SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html) | `string` | `"/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC | `bool` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | `null` | no |
| <a name="input_aws_metadata_options"></a> [aws\_metadata\_options](#input\_aws\_metadata\_options) | Customize the metadata options of the instance | `map(string)` | <pre>{<br/>  "http_endpoint": "enabled",<br/>  "http_put_response_hop_limit": 1,<br/>  "http_tokens": "optional"<br/>}</pre> | no |
| <a name="input_aws_network_interface"></a> [aws\_network\_interface](#input\_aws\_network\_interface) | Customize network interfaces to be attached at instance boot time | `list(map(string))` | `[]` | no |
| <a name="input_aws_prefix"></a> [aws\_prefix](#input\_aws\_prefix) | n/a | `string` | `"gosling-runner"` | no |
| <a name="input_aws_vm_create"></a> [aws\_vm\_create](#input\_aws\_vm\_create) | Whether to create an instance | `bool` | `true` | no |
| <a name="input_boot_disk"></a> [boot\_disk](#input\_boot\_disk) | (Required) The boot disk for the instance. The structure is documented below."<br/>The boot\_disk block supports:<br/><br/>  auto\_delete - (Optional) Defines whether the disk will be auto-deleted when the instance is deleted. The default value is True.<br/><br/>  device\_name - (Optional) Name that can be used to access an attached disk.<br/><br/>  mode - (Optional) Type of access to the disk resource. By default, a disk is attached in READ\_WRITE mode.<br/><br/>  disk\_id - (Optional) The ID of the existing disk (such as those managed by yandex\_compute\_disk) to attach as a boot disk.<br/><br/>  initialize\_params - (Optional) Parameters for a new disk that will be created alongside the new instance. Either initialize\_params or disk\_id must be set. The structure is documented below.<br/><br/>The initialize\_params block supports:<br/><br/>  name - (Optional) Name of the boot disk.<br/><br/>  description - (Optional) Description of the boot disk.<br/><br/>  size - (Optional) Size of the disk in GB.<br/><br/>  block\_size - (Optional) Block size of the disk, specified in bytes.<br/><br/>  type - (Optional) Disk type.<br/><br/>  image\_id - (Optional) A disk image to initialize this disk from.<br/><br/>  snapshot\_id - (Optional) A snapshot to initialize this disk from. | `any` | n/a | yes |
| <a name="input_capacity_reservation_specification"></a> [capacity\_reservation\_specification](#input\_capacity\_reservation\_specification) | Describes an instance's Capacity Reservation targeting option | `any` | `{}` | no |
| <a name="input_cloud-init"></a> [cloud-init](#input\_cloud-init) | (Required) Cloud init config script. | `string` | n/a | yes |
| <a name="input_core_fraction"></a> [core\_fraction](#input\_core\_fraction) | (Optional) If provided, specifies baseline performance for a core as a percent. | `number` | `null` | no |
| <a name="input_cpu_credits"></a> [cpu\_credits](#input\_cpu\_credits) | The credit option for CPU usage (unlimited or standard) | `string` | `null` | no |
| <a name="input_cpu_options"></a> [cpu\_options](#input\_cpu\_options) | Defines CPU options to apply to the instance at launch time. | `any` | `{}` | no |
| <a name="input_creation_zone"></a> [creation\_zone](#input\_creation\_zone) | (Mandatory) Zone where resources will be created | `string` | n/a | yes |
| <a name="input_disable_api_stop"></a> [disable\_api\_stop](#input\_disable\_api\_stop) | If true, enables EC2 Instance Stop Protection | `bool` | `null` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | If true, enables EC2 Instance Termination Protection | `bool` | `null` | no |
| <a name="input_ebs_block_device"></a> [ebs\_block\_device](#input\_ebs\_block\_device) | Additional EBS block devices to attach to the instance | `list(any)` | `[]` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` | no |
| <a name="input_enable_volume_tags"></a> [enable\_volume\_tags](#input\_enable\_volume\_tags) | Whether to enable volume tags (if enabled it conflicts with root\_block\_device tags) | `bool` | `true` | no |
| <a name="input_enclave_options_enabled"></a> [enclave\_options\_enabled](#input\_enclave\_options\_enabled) | Whether Nitro Enclaves will be enabled on the instance. Defaults to `false` | `bool` | `null` | no |
| <a name="input_ephemeral_block_device"></a> [ephemeral\_block\_device](#input\_ephemeral\_block\_device) | Customize Ephemeral (also known as Instance Store) volumes on the instance | `list(map(string))` | `[]` | no |
| <a name="input_filesystem"></a> [filesystem](#input\_filesystem) | (Optional) List of filesystems that are attached to the instance. Structure is documented below.<br/>The filesystem block supports:<br/><br/>  filesystem\_id - (Required) ID of the filesystem that should be attached.<br/><br/>  device\_name - (Optional) Name of the device representing the filesystem on the instance.<br/><br/>  mode - (Optional) Mode of access to the filesystem that should be attached. By default, filesystem is attached in READ\_WRITE mode. | `list(any)` | `[]` | no |
| <a name="input_get_password_data"></a> [get\_password\_data](#input\_get\_password\_data) | If true, wait for password data to become available and retrieve it | `bool` | `null` | no |
| <a name="input_group"></a> [group](#input\_group) | (Optional) Which group of host is it? | `string` | `"application"` | no |
| <a name="input_hibernation"></a> [hibernation](#input\_hibernation) | If true, the launched EC2 instance will support hibernation | `bool` | `null` | no |
| <a name="input_host_id"></a> [host\_id](#input\_host\_id) | ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host | `string` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile | `string` | `null` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance | `string` | `null` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Additional tags for the instance | `map(string)` | `{}` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to start | `string` | `"t3.micro"` | no |
| <a name="input_ipv6_address_count"></a> [ipv6\_address\_count](#input\_ipv6\_address\_count) | A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet | `number` | `null` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource | `string` | `null` | no |
| <a name="input_launch_template"></a> [launch\_template](#input\_launch\_template) | Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template | `map(string)` | `{}` | no |
| <a name="input_local_disk"></a> [local\_disk](#input\_local\_disk) | (Optional) List of local disks that are attached to the instance. Structure is documented below.<br/>The local\_disk block supports:<br/><br/>  size\_bytes - (Required) Size of the disk, specified in bytes.<br/><br/>NOTE:<br/><br/>Local disks are not available for all users by default. | `list(any)` | `[]` | no |
| <a name="input_maintenance_options"></a> [maintenance\_options](#input\_maintenance\_options) | The maintenance options for the instance | `any` | `{}` | no |
| <a name="input_metadata_options"></a> [metadata\_options](#input\_metadata\_options) | (Optional) Options allow user to configure access to instance's metadata | `any` | `{}` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `null` | no |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | (Optional) Type of network acceleration. The default is standard. Values: standard, software\_accelerated | `string` | `"standard"` | no |
| <a name="input_network_interface"></a> [network\_interface](#input\_network\_interface) | (Required) Networks to attach to the instance. This can be specified multiple times. The structure is documented below.<br/>The network\_interface block supports:<br/><br/>  subnet\_id - (Required) ID of the subnet to attach this interface to. The subnet must exist in the same zone where this instance will be created.<br/><br/>  ipv4 - (Optional) Allocate an IPv4 address for the interface. The default value is true.<br/><br/>  ip\_address - (Optional) The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet.<br/><br/>  ipv6 - (Optional) If true, allocate an IPv6 address for the interface. The address will be automatically assigned from the specified subnet.<br/><br/>  ipv6\_address - (Optional) The private IPv6 address to assign to the instance.<br/><br/>  nat - (Optional) Provide a public address, for instance, to access the internet over NAT.<br/><br/>  nat\_ip\_address - (Optional) Provide a public address, for instance, to access the internet over NAT. Address should be already reserved in web UI.<br/><br/>  security\_group\_ids - (Optional) Security group ids for network interface.<br/><br/>  dns\_record - (Optional) List of configurations for creating ipv4 DNS records. The structure is documented below.<br/><br/>  ipv6\_dns\_record - (Optional) List of configurations for creating ipv6 DNS records. The structure is documented below.<br/><br/>  nat\_dns\_record - (Optional) List of configurations for creating ipv4 NAT DNS records. The structure is documented below.<br/><br/>The dns\_record block supports:<br/><br/>  fqdn - (Required) DNS record FQDN (must have a dot at the end).<br/><br/>  dns\_zone\_id - (Optional) DNS zone ID (if not set, private zone used).<br/><br/>  ttl - (Optional) DNS record TTL. in seconds<br/><br/>  ptr - (Optional) When set to true, also create a PTR DNS record.<br/><br/>The ipv6\_dns\_record block supports:<br/><br/>  fqdn - (Required) DNS record FQDN (must have a dot at the end).<br/><br/>  dns\_zone\_id - (Optional) DNS zone ID (if not set, private zone used).<br/><br/>  ttl - (Optional) DNS record TTL. in seconds<br/><br/>  ptr - (Optional) When set to true, also create a PTR DNS record.<br/><br/>The nat\_dns\_record block supports:<br/><br/>  fqdn - (Required) DNS record FQDN (must have a dot at the end).<br/><br/>  dns\_zone\_id - (Optional) DNS zone ID (if not set, private zone used).<br/><br/>  ttl - (Optional) DNS record TTL. in seconds<br/><br/>  ptr - (Optional) When set to true, also create a PTR DNS record. | `any` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Optional) Lables with owner markers | `string` | `"linde-gas-rus-is"` | no |
| <a name="input_placement_group"></a> [placement\_group](#input\_placement\_group) | The Placement Group to start the instance in | `string` | `null` | no |
| <a name="input_placement_policy"></a> [placement\_policy](#input\_placement\_policy) | (Optional) The placement policy configuration. The structure is documented below.<br/>The placement\_policy block supports:<br/><br/>  placement\_group\_id - (Optional) Specifies the id of the Placement Group to assign to the instance.<br/><br/>  host\_affinity\_rules - (Optional) List of host affinity rules. The structure is documented below.<br/><br/>The host\_affinity\_rules block supports:<br/><br/>  key - (Required) Affinity label or one of reserved values - yc.hostId, yc.hostGroupId.<br/><br/>  op - (Required) Affinity action. The only value supported is IN.<br/><br/>  value - (Required) List of values (host IDs or host group IDs). | `list(any)` | `[]` | no |
| <a name="input_private_dns_name_options"></a> [private\_dns\_name\_options](#input\_private\_dns\_name\_options) | Customize the private DNS name options of the instance | `map(string)` | `{}` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in a VPC | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Customize details about the root block device of the instance. See Block Devices below for details | `list(any)` | `[]` | no |
| <a name="input_scheduling_policy"></a> [scheduling\_policy](#input\_scheduling\_policy) | (Optional) Scheduling policy configuration. The structure is documented below.<br/>The scheduling\_policy block supports:<br/><br/>  preemptible - (Optional) Specifies if the instance is preemptible. Defaults to false. | `any` | `{}` | no |
| <a name="input_secondary_disk"></a> [secondary\_disk](#input\_secondary\_disk) | (Optional) A list of disks to attach to the instance. The structure is documented below.<br/>Note: The allow\_stopping\_for\_update property must be set to true in order to update this structure.<br/>The secondary\_disk block supports:<br/><br/>  disk\_id - (Required) ID of the disk that is attached to the instance.<br/><br/>  auto\_delete - (Optional) Whether the disk is auto-deleted when the instance is deleted. The default value is false.<br/><br/>  device\_name - (Optional) Name that can be used to access an attached disk under /dev/disk/by-id/.<br/><br/>  mode - (Optional) Type of access to the disk resource. By default, a disk is attached in READ\_WRITE mode. | `list(any)` | `[]` | no |
| <a name="input_secondary_private_ips"></a> [secondary\_private\_ips](#input\_secondary\_private\_ips) | A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block` | `list(string)` | `null` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | (Optional) ID of the service account authorized for this instance. | `string` | `null` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool` | `null` | no |
| <a name="input_source_image_family"></a> [source\_image\_family](#input\_source\_image\_family) | (Optional) The family name of an image. Used to search the latest image in a family. | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_source_image_id"></a> [source\_image\_id](#input\_source\_image\_id) | (Optional) The ID of a specific image. | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The VPC Subnet ID to launch in | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_tenancy"></a> [tenancy](#input\_tenancy) | The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | (Optional) Timeouts for creation, deletion and update. | `string` | `"15m"` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting EC2 instance resources | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user\_data\_base64 instead | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of user\_data to pass base64-encoded binary data directly. Use this instead of user\_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | When used in combination with user\_data or user\_data\_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set | `bool` | `null` | no |
| <a name="input_vault-token"></a> [vault-token](#input\_vault-token) | (Optional) Temporary meradata deploy vault token. | `string` | `null` | no |
| <a name="input_vm_ram_qty"></a> [vm\_ram\_qty](#input\_vm\_ram\_qty) | (Required) Memory size in GB. | `number` | `2` | no |
| <a name="input_vm_vcpu_qty"></a> [vm\_vcpu\_qty](#input\_vm\_vcpu\_qty) | (Required) CPU cores for the instance. | `number` | `2` | no |
| <a name="input_vm_vcpu_type"></a> [vm\_vcpu\_type](#input\_vm\_vcpu\_type) | n/a | `string` | `"standard-v2"` | no |
| <a name="input_volume_tags"></a> [volume\_tags](#input\_volume\_tags) | A mapping of tags to assign to the devices created by the instance at launch time | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | A list of security group IDs to associate with | `list(string)` | `null` | no |
| <a name="input_yc_create"></a> [yc\_create](#input\_yc\_create) | Whether to create an instance | `bool` | `true` | no |
| <a name="input_yc_prefix"></a> [yc\_prefix](#input\_yc\_prefix) | n/a | `string` | `"gosling-runner"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | n/a |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->
