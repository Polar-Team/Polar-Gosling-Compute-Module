# Description: This script sets up environment variables for AWS credentials and region for use in Conftest.
param (
  [string]$REGION = "us-east-1"
)


aws sso login --profile $env:AWS_PROFILE
$env:AWS_REGION = $REGION

$env:YC_TOKEN = $(yc iam create-token)
$env:YC_CLOUD_ID = $(yc config get cloud-id)
$env:YC_FOLDER_ID = $(yc config get folder-id)
