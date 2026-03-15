#!/bin/bash
# This script sets up temporary AWS credentials for use with conftest
# Obtain temporary AWS credentials using AWS STS

REGION=${1:-"us-east-1"}

# Set the AWS profile to use for authentication
aws sso login --prfile "${AWS_PROFILE}"
AWS_REGION="${REGION}"
export AWS_REGION

# Get temporary YC token, folder ID, and cloud ID
YC_TOKEN=$(yc iam create-token)
YC_CLOUD_ID=$(yc config get cloud-id)
YC_FOLDER_ID=$(yc config get folder-id)
export YC_CLOUD_ID
export YC_FOLDER_ID
export YC_TOKEN

# Set up TF_VAR environment variables for Terraform
TF_VAR_yc_folder_id="${YC_FOLDER_ID}"
export TF_VAR_yc_folder_id
