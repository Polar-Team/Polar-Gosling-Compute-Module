terraform {
  required_version = ">= 1.3.5"
  required_providers {
    yandex = {
      source  = "registry.terraform.io/yandex-cloud/yandex"
      version = ">= 0.170.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
  }
}


