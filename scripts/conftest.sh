#!/bin/bash
# This script sets up temporary AWS credentials for use with conftest
# Obtain temporary AWS credentials using AWS STS

REGION=${1:-"us-east-1"}
AWS_CREDENTIALS=$(aws sts get-session-token --duration-seconds 3600)
AWS_KEY_ID=$("${AWS_CREDENTIALS}" | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_KEY=$("${AWS_CREDENTIALS}" | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$("${AWS_CREDENTIALS}" | jq -r '.Credentials.SessionToken')
AWS_REGION="${REGION}"
export AWS_KEY_ID
export AWS_SECRET_KEY
export AWS_SESSION_TOKEN
export AWS_REGION

YC_TOKEN=$(yc iam create-token)
YC_CLOUD_ID=$(yc config get cloud-id)
YC_FOLDER_ID=$(yc config get folder-id)
export YC_CLOUD_ID
export YC_FOLDER_ID
export YC_TOKEN
