# Description: This script sets up environment variables for AWS credentials and region for use in Conftest.
param (
  [string]$REGION = "us-east-1"
)

$AWS_CREDENTIALS = $(aws sts get-session-token --duration-seconds 3600 | ConvertFrom-Json)

$env:AWS_ACCESS_KEY_ID = $AWS_CREDENTIALS.Credentials.AccessKeyId
$env:AWS_SECRET_ACCESS_KEY = $AWS_CREDENTIALS.Credentials.SecretAccessKey
$env:AWS_SESSION_TOKEN = $AWS_CREDENTIALS.Credentials.SessionToken
$env:AWS_REGION = $REGION

$env:YC_TOKEN = $(yc iam create-token)
$env:YC_CLOUD_ID = $(yc config get cloud-id)
$env:YC_FOLDER_ID = $(yc config get folder-id)
