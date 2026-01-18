data "external" "os" {
  program = ["bash", "${path.module}/detect.sh"]
}

data "external" "registry_id" {
  program    = ["yc", "container", "registry", "get", "test-registry", "--format", "json"]
  depends_on = [yandex_container_registry.test_registry]
}


data "yandex_client_config" "client" {}

locals {
  docker_image_upload_cmd = <<-EOF
  docker login cr.yandex --username IAM --password $(yc iam create-token);
  docker pull nginx:latest;
  docker tag nginx:latest cr.yandex/${yandex_container_repository.test_repository.name}:latest;
  docker push cr.yandex/${yandex_container_repository.test_repository.name}:latest;
  docker image rm  -f cr.yandex/${yandex_container_repository.test_repository.name}:latest;
  EOF
  docker_interpreter      = data.external.os.result.os == "Windows" ? ["PowerShell", "-Command"] : ["bash", "-c"]
}


resource "yandex_vpc_network" "test_network_2" {
  name = "test-network-2"
}

resource "yandex_container_registry" "test_registry" {
  name = "test-registry"
}

resource "yandex_container_repository" "test_repository" {
  name = "${yandex_container_registry.test_registry.id}/test-repository"
}

resource "null_resource" "upload_docker_image" {
  provisioner "local-exec" {
    command     = chomp(replace(local.docker_image_upload_cmd, "\r\n", "\n"))
    interpreter = local.docker_interpreter
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    $REGISTRY=$(yc container registry get test-registry --format json | jq .id);
    $CONTAINER=$(yc container image get $REGISTRY/
    yc container image delete $REGISTRY/test-repository:latest
    EOT
  }


  depends_on = [yandex_container_repository.test_repository]
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

  serverless_image = {
    url     = "cr.yandex/${yandex_container_repository.test_repository.name}:latest"
    command = ["/bin/sh", "-c", "echo Hello, OpenTofu! && sleep 3600"]
    environment = {
      ENV_VAR_1 = "value1"
      ENV_VAR_2 = "value2"
    }
  }

  serverless_connectivity = {
    network_id = yandex_vpc_network.test_network_2.id
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
  depends_on = [null_resource.upload_docker_image]

}
