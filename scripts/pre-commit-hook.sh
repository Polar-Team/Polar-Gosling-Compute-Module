#!/bin/bash
git init
export VERSION="v2.2.2"
export REPO="https://github.com/tofuutils/pre-commit-opentofu"

cat >.pre-commit-config.yaml <<EOL
repos:
- repo: $REPO
  rev: $VERSION # Get the latest from: $REPO/releases
  hooks:
    - id: tofu_fmt
    - id: tofu_validate
      exclude: 'tests/*'
      args:
        - --tf-init-args=-upgrade
    - id: tofu_checkov
      args:
        - --args=--skip-check CKV_AWS_41
        - --args=--skip-check CKV_AWS_65
        - --args=--skip-check CKV_AWS_88
        - --args=--skip-check CKV_AWS_224
        - --args=--skip-check CKV_AWS_249
    - id: tofu_tflint
      exclude: 'tests/*'
      args:
        - --args=--enable-rule=terraform_deprecated_interpolation
        - --args=--enable-rule=terraform_deprecated_index
        - --args=--enable-rule=terraform_empty_list_equality
        - --args=--enable-rule=terraform_module_pinned_source
        - --args=--enable-rule=terraform_module_version
        - --args=--enable-rule=terraform_required_providers
        - --args=--enable-rule=terraform_required_version
        - --args=--enable-rule=terraform_typed_variables
        - --args=--enable-rule=terraform_unused_declarations
        - --args=--enable-rule=terraform_unused_required_providers
        - --args=--enable-rule=terraform_workspace_remote
    - id: tofu_docs
      exclude: 'tests/*'
      args:
        - --hook-config=--path-to-file=README.md        # Valid UNIX path. I.e. ../TFDOC.md or docs/README.md etc.
        - --hook-config=--add-to-existing-file=true     # Boolean. true or false
        - --hook-config=--create-file-if-not-exist=true # Boolean. true or false
EOL

function setup_deps {

  # Install pre-commit if not already installed
  if ! command -v pre-commit &>/dev/null; then
    echo -e "\e[33mpre-commit could not be found, installing...\e[0m"
    sudo pip install pre-commit
  else
    echo -e "\033[0;32mpre-commit is already installed\033[0m"
  fi

  # Install tflint if not already installed
  if ! command -v tflint &>/dev/null; then
    echo -e "\e[33mtflint could not be found, installing...\e[0m"
    sudo curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  else
    echo -e "\033[0;32mtflint is already installed\033["
  fi

  # Install checkov if not already installed
  if ! command -v checkov &>/dev/null; then
    echo -e "\e[33mcheckov could not be found, installing...\e[0m"
    sudo pip install checkov
  else
    echo -e "\033[0;32mcheckov is already installed\033[0m"
  fi

  # Install terraform_docs
  if ! command -v terraform-docs &>/dev/null; then
    echo -e "\e[33mterraform-docs could not be found, installing...\e[0m"
    sudo curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/releases/terraform-docs-v0.16.0-linux-amd64.tar.gz &&
      sudo tar -xzf terraform-docs.tar.gz &&
      sudo chmod +x terraform-docs &&
      sudo mv terraform-docs /bin/terraform-docs
  else
    echo -e "\033[0;32mterraform-docs is already installed\033[0m"
  fi
}

if [ -d "/mnt/c" ]; then
  setup_deps
  cat >.git/hooks/pre-commit <<EOL
#!/bin/bash
wsl -e pre-commit run -a
EOL
else
  setup_deps
  cat >.git/hooks/pre-commit <<EOL
#!/bin/bash
export TF_CLI_CONFIG_FILE="./terraform.rc" && pre-commit run -a
EOL
fi
