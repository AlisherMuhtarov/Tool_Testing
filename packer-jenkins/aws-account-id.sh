#!/bin/bash
# Export AWS account ID to /tmp/aws_account_id.txt
aws sts get-caller-identity --query "Account" --output text > /tmp/aws_account_id.txt
export AWS_ACCOUNT_ID=$(cat /tmp/aws_account_id.txt)