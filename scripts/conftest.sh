#!/bin/bash
# This script sets up temporary AWS credentials for use with conftest
# Obtain temporary AWS credentials using AWS STS

REGION=${1:-"us-east-1"}
aws sso login --prfile "${AWS_PROFILE}"
AWS_REGION="${REGION}"
export AWS_REGION

YC_TOKEN=$(yc iam create-token)
YC_CLOUD_ID=$(yc config get cloud-id)
YC_FOLDER_ID=$(yc config get folder-id)
export YC_CLOUD_ID
export YC_FOLDER_ID
export YC_TOKEN
