data "external" "os" {
  program = ["bash", "${path.module}/detect.sh"]
}

data "yandex_vpc_network" "test_network" {
  name = "test-network"
}

data "yandex_client_config" "client" {}


locals {
  docker_image_upload_cmd = <<-EOF
  docker login cr.yandex --username IAM --password $(yc iam create-token);
  docker pull nginx:latest;
  docker tag nginx:latest ${var.test_repository_link}:latest;
  docker push ${var.test_repository_link}:latest;
  docker image rm  -f ${var.test_repository_link}:latest;
  docker image rm -f nginx:latest;
  EOF
  docker_interpreter      = data.external.os.result.os == "Windows" ? ["PowerShell", "-Command"] : ["bash", "-c"]
}

variable "test_repository_link" {
  type    = string
  default = "cr.yandex/crpkv7edjchv2v68ro2g/test-nginx-container"
}

resource "null_resource" "upload_docker_image" {

  provisioner "local-exec" {
    command     = chomp(replace(local.docker_image_upload_cmd, "\r\n", "\n"))
    interpreter = local.docker_interpreter
  }
}

resource "yandex_iam_service_account" "serverless_sa" {
  name = "serverless-service-account"
}

resource "yandex_resourcemanager_folder_iam_member" "serverless_permissions" {
  for_each   = toset(["container-registry.images.puller", "serverless-containers.admin"])
  role       = each.key
  folder_id  = data.yandex_client_config.client.folder_id
  member     = "serviceAccount:${yandex_iam_service_account.serverless_sa.id}"
  depends_on = [yandex_iam_service_account.serverless_sa]
}

module "yc_test_serverless" {
  source               = "../../"
  yc_serverless_create = true
  service_account_id   = yandex_iam_service_account.serverless_sa.id

  serverless_image = {
    url     = "${var.test_repository_link}:latest"
    command = ["/bin/sh", "-c", "echo Hello, OpenTofu! && sleep 3600"]
    environment = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }

  serverless_connectivity = {
    network_id = data.yandex_vpc_network.test_network.id
  }

  serverless_description       = "Test Serverless Function created by OpenTofu"
  serverless_execution_timeout = "3600s"

  serverless_runtime = {
    type = "http"
  }

  serverless_provision_policy = {
    min_instances = 1
  }

  serverless_async_invocation = {
    service_account_id = yandex_iam_service_account.serverless_sa.id
  }

  additional_labels = {
    environment = "test"
    purpose     = "opentofu-yc-serverless-test"
  }

  depends_on = [
    null_resource.upload_docker_image,
    yandex_resourcemanager_folder_iam_member.serverless_permissions
  ]

}
