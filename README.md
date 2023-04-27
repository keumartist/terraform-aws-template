# Terraform Template for AWS

This template sets up Lambda, API Gateway, a static website, Route53, ACM, DynamoDB, and IAM

Easily create a serverless API and static website using this template

## How to use

### Initialize terraform

`terraform -chdir=terraform/env/dev init`

### Create execution plan

`terraform -chdir=terraform/env/dev plan`

### Execute the actions proposed in plan. This command will create and modify actual resources

`terraform -chdir=terraform/env/dev apply`
