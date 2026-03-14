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
      exclude: '(\.github/|tests/)'
    - id: tofu_validate
      exclude: '(\.github/|tests/)'
      args:
        - --tf-init-args=-upgrade
    - id: tofu_checkov
      args:
        - --args=--skip-check CKV_AWS_41
        - --args=--skip-check CKV_AWS_65
        - --args=--skip-check CKV_AWS_88
        - --args=--skip-check CKV_AWS_224
        - --args=--skip-check CKV_AWS_249
        - --args=--skip-check CKV2_GHA_1
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

  # Ensure ~/.local/bin is in PATH (pip installs checkov here)
  export PATH="$HOME/.local/bin:$PATH"

  # Install pre-commit if not already installed
  if ! command -v pre-commit &>/dev/null; then
    echo -e "\e[33mpre-commit could not be found, installing...\e[0m"
    pip install pre-commit --break-system-packages
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
    sudo pip3 install -U checkov --break-system-packages --ignore-installed
  else
    echo -e "\033[0;32mcheckov is already installed\033[0m"
  fi

  # Install terraform_docs
  if ! command -v terraform-docs &>/dev/null; then
    echo -e "\e[33mterraform-docs could not be found, installing...\e[0m"
    curl -sSLo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz &&
      tar -xzf terraform-docs.tar.gz &&
      chmod +x terraform-docs &&
      sudo mv terraform-docs /usr/local/bin/terraform-docs &&
      rm -f terraform-docs.tar.gz
  else
    echo -e "\033[0;32mterraform-docs is already installed\033[0m"
  fi

  # Install OpenTofu (tofu) if not already installed
  if ! command -v tofu &>/dev/null; then
    echo -e "\e[33mtofu could not be found, installing...\e[0m"
    TOFU_VERSION=$(curl -sSL https://api.github.com/repos/opentofu/opentofu/releases/latest | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -sSLo ./tofu.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.tar.gz" &&
      tar -xzf tofu.tar.gz tofu &&
      chmod +x tofu &&
      sudo mv tofu /usr/local/bin/tofu &&
      rm -f tofu.tar.gz
  else
    echo -e "\033[0;32mtofu is already installed ($(tofu version | head -1))\033[0m"
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
