# Deploy an EKS Cluster using Terraform

This code uses Terraform AWS provider and a single module to reuse the code in multiple enviroments, in this case I created 2 directories for environment "dev-us-east-1" and "prod-us-east".
I have only instiated the code on the  "dev-us-east-1" environments for the purpose of the demo.

## Requirements
- Terraform 1.5.5
- Terraform AWS Provider ~> 5.65.0

## How it works
1. Create VPC
1. Create Internet Gateway
1. Create a Subnet
    1. Decided to make subnets private to reduce costs
1. Create one Elastic IP per Subnet
1. Create one NAT Gateway per Subnet
    - This is required to allocate the EIPs and hence the rest of the resources need to be created one per subnet
1. Create Route Tables
1. Create Routes and Associations
1. Create Security Group
    - Allow all outbound IPv4 traffic 
    - Allow all outbound IPv6 traffic
    - Allow all inboud traffic from the Worker Nodes
1. Create SSH key pair    
1. Create IAM Role for EKS Cluster
    - Attach the policy
1. Create EKS Cluster
1. Create IAM Role for EKS Nodes Pools
    - Attach the policy
1. Create EKS Nodes Pools
    - Set node configurations
1. Outputs
    - name
    - endpoint
    - certificate_authority
    - vpc_id


## Execution from Pipeline
**To trigger a plan**
- Go to the repo Actions
- Run a Manual Workflow Dispatch "Plan dev-us-east-1"
- The Pipeline will run and show all the resources to be created on AWS with Terraform

Notes:
- The pipeline doesnt a have backend on purpose to avoid costs, altought its connected to my personal account so the plan can succesfully run.
- For this reason any apply wont work



## Execution Locally

1. Clone the repository into your local machine
1. Move to the directory you want to work on 
    - For example `environments/dev-us-east-1`
1. Export the following environment variables:
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`
    - `AWS_REGION`
1. The code has already defined a default attributes to instantiate the code you can change the values as required, for example: **tags, cluster name, subnet count, CIDR block, capacity type, instance type, node pool size, labels and taints.**
1. Run `terraform init`
1. Run `terraform plan` or `terraform apply`
1. Run `terraform destroy` to remove the resources

