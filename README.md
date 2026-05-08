# Terraform Azure Infrastructure with Azure DevOps

This repository provisions Azure infrastructure using Terraform and deploys it through an Azure DevOps YAML pipeline.

## Provisioned Resources

- Resource Group
- Virtual Network and Subnet
- Network Security Group (RDP rule on port `3389`)
- Two Windows Virtual Machines with public/private IP outputs

## Repository Structure

- `main.tf`, `variables.tf`, `outputs.tf` - root composition and shared variables
- `modules/network` - VNet, Subnet, NSG resources
- `modules/windows-vm` - reusable Windows VM module
- `backend.tf` - remote state backend block (configured at runtime from pipeline variables)
- `azure-pipelines.yml` - CI/CD pipeline definition
- `terraform.tfvars.example` - non-sensitive variable example

## Prerequisites

- Azure subscription
- Azure DevOps project: `terraform-azure-project`
- Azure DevOps Service Connection with contributor access to target subscription
- Existing storage backend for state:
  - Resource Group: `tfstate-rg`
  - Storage Account: `tfstatekp2026dev123`
  - Blob Container: `tfstate`

## Local Deployment Steps

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Set secret locally (do not store in file):
   - `export TF_VAR_admin_password='<strong-password>'`
3. Run:
   - `terraform init -backend-config="resource_group_name=tfstate-rg" -backend-config="storage_account_name=tfstatekp2026dev123" -backend-config="container_name=tfstate" -backend-config="key=terraform.tfstate"`
   - `terraform validate`
   - `terraform plan -out=tfplan`
   - `terraform apply tfplan`

## Azure DevOps Pipeline

The pipeline (`azure-pipelines.yml`) supports separate branch-based environments:

1. **Validate (all branches)**
   - `terraform fmt -check -recursive`
   - `terraform init -backend=false`
   - `terraform validate`
2. **Dev flow (`develop` branch)**
   - `PlanDev`: uses backend key `terraform-dev.tfstate`
   - `ApplyDev`: deployment job targeting environment `dev`
3. **Prod flow (`main` branch)**
   - `PlanProd`: uses backend key `terraform-prod.tfstate`
   - `ApplyProd`: deployment job targeting environment `prod`
   - Configure environment approvals in Azure DevOps for manual production gates

## Azure DevOps Setup Instructions

1. Push this repository to an Azure DevOps repo under your project.
2. In Azure DevOps, create a new pipeline and select existing YAML: `azure-pipelines.yml`.
3. Ensure pipeline variable `azureServiceConnection` matches your service connection name (default: `azure-terraform-conn`).
4. Create Azure DevOps Environments:
   - `dev` (optional approvals)
   - `prod` (required approvals)
5. Add secret pipeline variable:
   - `TF_VAR_admin_password` (mark as secret)

## Security and Best Practices Implemented

- Remote state is stored in Azure Storage (not local machine).
- Sensitive values are not committed to git (`terraform.tfvars` is ignored).
- Password is injected through secret variable (`TF_VAR_admin_password`).
- Plan and apply are separated so what is approved is exactly what is deployed.
- Branch-based promotion:
  - `develop` -> dev state and `dev` environment
  - `main` -> prod state and approval-gated `prod` environment

## Assumptions and Design Decisions

- Backend storage resources already exist and are managed separately.
- RDP access is currently open (`*`) for assessment/demo simplicity; for production, restrict source IP ranges.
- Infrastructure naming is intentionally straightforward for readability in assessment context.
