# Polar Gosling Compute Module

A reusable OpenTofu module for provisioning GitLab CI runners across **AWS** (EC2, ECS Fargate) and **Yandex Cloud** (Compute VM, Serverless Container).

> This module is part of the [Polar Gosling](https://github.com/your-org/Polar-Gosling) GitOps runner orchestration system. It is used by **MotherGoose** to automatically deploy and tear down runners in response to GitLab webhook events and Git sync cycles. You typically do not need to invoke this module directly — MotherGoose manages it via OpenTofu + Jinja2 templates.

## Cloud targets

| Resource | AWS | Yandex Cloud |
|---|---|---|
| VM | EC2 | Compute VM |
| Serverless | ECS Fargate | Serverless Container |

Toggle creation with `aws_vm_create`, `aws_ecs_create`, `yc_vm_create`, `yc_serverless_create`.

## Usage

The module is split into two per-cloud submodules so that single-cloud consumers avoid pulling in the other cloud's provider. Source the submodule for your target cloud directly:

```hcl
# YC-only: no AWS provider needed at all
module "runner" {
  source       = "git::https://github.com/your-org/Polar-Gosling-Compute-Module.git//modules/yc?ref=v2.0.0"
  yc_vm_create = true
  # ...
}
```

```hcl
# AWS-only: no Yandex provider needed at all
module "runner" {
  source        = "git::https://github.com/your-org/Polar-Gosling-Compute-Module.git//modules/aws?ref=v2.0.0"
  aws_vm_create = true
  # ...
}
```

### From a specific release zip

Download the artifact from the [Releases](https://github.com/your-org/Polar-Gosling-Compute-Module/releases) page, extract it, and reference the local path:

```hcl
module "runner" {
  source = "./polar-gosling-compute-module/modules/aws"
  # ...
}
```

### Verifying release integrity

Each release ships a SHA256 checksum, a Cosign bundle, and a SLSA provenance attestation.

```bash
# Verify checksum
sha256sum -c polar-gosling-compute-module.zip.sha256

# Verify Cosign signature (keyless)
cosign verify-blob \
  --bundle polar-gosling-compute-module.zip.bundle \
  polar-gosling-compute-module.zip

# Verify SLSA provenance
gh attestation verify polar-gosling-compute-module.zip \
  --repo your-org/Polar-Gosling-Compute-Module
```

## Requirements

Each submodule declares its own provider requirements:

| Submodule | Provider | Version |
|-----------|----------|---------|
| `modules/aws` | opentofu | >= 1.3.5 |
| `modules/aws` | hashicorp/aws | >= 4.66 |
| `modules/aws` | hashicorp/random | >= 3.4.3 |
| `modules/yc` | opentofu | >= 1.3.5 |
| `modules/yc` | yandex-cloud/yandex | >= 0.170.0 |
| `modules/yc` | hashicorp/random | >= 3.4.3 |

## Custom provider mirror (terraform.rc)

If you are running in an air-gapped environment or want to use a private OCI registry as a provider mirror, create a `terraform.rc` (Linux/macOS: `~/.terraformrc`) with:

```hcl
provider_installation {
  oci_mirror {
    repository_template = "your-registry.example.com/${namespace}/${name}"
    include             = ["registry.opentofu.org/*"]
  }

  # Fallback to public registry for anything not in the mirror
  direct {
    exclude = ["your-private-provider/*"]
  }
}
```

Then point OpenTofu at it:

```bash
export TF_CLI_CONFIG_FILE="./terraform.rc"
tofu init
```

The `terraform.rc` files inside each `tests/` subdirectory already use this pattern with an OCI mirror — they serve as a working reference.
