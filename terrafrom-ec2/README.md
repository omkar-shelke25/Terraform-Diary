# Index

1. **[Terraform Overview](#terraform-overview)**
   - Definition
   - Key Features

2. **[Terraform Configuration Files](#terraform-configuration-files)**
   - Components of a Terraform Configuration File
     - [Provider Block](./terraform-basic.md)
     - Resource Block
     - Variable Block
     - Output Block
     - Data Sources
     - Module Block

3. **[Creating an AWS EC2 Instance Using Terraform](#creating-an-aws-ec2-instance-using-terraform)**
   - Prerequisites
     - Terraform Installed
     - AWS CLI Installed and Configured
   - Steps to Create an [EC2 Instance](./aws-concept.md)
     - Create a Directory for Your [Terraform Configuration](./terraform-confi-file.md)
     - Create a Main Configuration File
     - Initialize Terraform
     - Plan the Deployment
     - Apply the Configuration
     - Check the Output
     - Destroy the Instance (Optional)
   - Notes
     - AMI ID
     - [Instance Type](./aws-concept.md)
     - Terraform State

4. **[Use of Terraform](#use-of-terraform)**
   - Infrastructure Provisioning
   - Benefits
     - Consistency
     - Reusability
     - Version Control
     - State Management
     - Multi-Provider Support

5. **[Common Commands](#common-commands)**
   - `terraform init`
   - `terraform plan`
   - `terraform apply`
   - `terraform destroy`





## Provisioning an AWS EC2 Instance with Terraform

## Terraform Overview

### Definition
Terraform is an open-source infrastructure as code (IaC) tool created by HashiCorp. It allows users to define and provision infrastructure using a high-level configuration language, known as HashiCorp Configuration Language (HCL), or JSON. Terraform can manage various infrastructure components such as virtual machines, networks, and storage, across multiple cloud providers and on-premises environments.

### Key Features
- **Declarative Configuration**: Users define what they want their infrastructure to look like, and Terraform figures out how to achieve that state.
- **Version Control**: Terraform configurations can be versioned and treated like code, which enables tracking changes and collaboration.
- **Provider Support**: Terraform supports numerous cloud providers and services through plugins called providers.
- **State Management**: Terraform maintains a state file that tracks the resources it manages, ensuring that changes are applied correctly and consistently.

## Terraform Configuration Files

### Components of a Terraform Configuration File
1. **Provider Block**
   - Defines the provider (e.g., AWS, Azure, Google Cloud) that Terraform will use to manage resources.
   - Example:
     ```hcl
     provider "aws" {
       region = "us-east-1"
     }
     ```

2. **Resource Block**
   - Defines the infrastructure resources to be created or managed.
   - Example:
     ```hcl
     resource "aws_instance" "example" {
       ami           = "ami-0c55b159cbfafe1f0"
       instance_type = "t2.micro"
     }
     ```

3. **Variable Block**
   - Defines variables that can be used to customize configurations.
   - Example:
     ```hcl
     variable "instance_type" {
       type    = string
       default = "t2.micro"
     }
     ```

4. **Output Block**
   - Defines outputs that are returned after Terraform applies the configuration, which can be used for referencing values in other configurations.
   - Example:
     ```hcl
     output "instance_id" {
       value = aws_instance.example.id
     }
     ```

5. **Data Sources**
   - Allows Terraform to fetch data from external sources or existing infrastructure.
   - Example:
     ```hcl
     data "aws_ami" "latest_amazon_linux" {
       most_recent = true
       owners      = ["amazon"]
     }
     ```

6. **Module Block**
   - Allows for the reuse of configurations by creating reusable components.
   - Example:
     ```hcl
     module "vpc" {
       source = "./modules/vpc"
       name   = "my-vpc"
     }
     ```

Sure! Here’s how you can create an AWS EC2 instance using Terraform, including the relevant notes for the process:

---

## Creating an AWS EC2 Instance Using Terraform

### Prerequisites
- **Terraform Installed**: Ensure that Terraform is installed on your local machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html).
- **AWS CLI Installed and Configured**: Install and configure the AWS CLI with your AWS credentials. You can configure it using `aws configure` command.

### Steps to Create an EC2 Instance

1. **Create a Directory for Your Terraform Configuration**
   ```bash
   mkdir terraform-ec2
   cd terraform-ec2
   ```

2. **Create a Main Configuration File**
   Create a file named `main.tf` with the following content:

   ```hcl
   # Specify the provider
   provider "aws" {
     region = "us-east-1"  # Change to your preferred region
   }

   # Define the EC2 instance resource
   resource "aws_instance" "example" {
     ami           = "ami-0c55b159cbfafe1f0"  # Update with the latest Amazon Linux 2 AMI ID for your region
     instance_type = "t2.micro"

     tags = {
       Name = "example-instance"
     }
   }

   # Output the instance ID
   output "instance_id" {
     value = aws_instance.example.id
   }
   ```

   **Explanation**:
   - **provider** block: Specifies the AWS region.
   - **resource** block: Defines an `aws_instance` resource with an Amazon Machine Image (AMI) and instance type. Adjust the AMI ID and instance type as needed.
   - **output** block: Outputs the instance ID after the instance is created.

3. **Initialize Terraform**
   Run the following command to initialize your Terraform workspace. This will download the necessary provider plugins.
   ```bash
   terraform init
   ```

4. **Plan the Deployment**
   Generate and review an execution plan to see what Terraform will do before applying changes.
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   Apply the configuration to create the EC2 instance.
   ```bash
   terraform apply
   ```
   Confirm the action by typing `yes` when prompted.

6. **Check the Output**
   After applying the configuration, Terraform will display the instance ID as specified in the `output` block.

7. **Destroy the Instance (Optional)**
   If you want to remove the EC2 instance, run:
   ```bash
   terraform destroy
   ```
   Confirm the action by typing `yes` when prompted.

### Notes
- **AMI ID**: Ensure you use the correct AMI ID for the region you are working in. You can find the latest AMI IDs in the AWS Management Console or use the AWS CLI to list available AMIs.
- **Instance Type**: `t2.micro` is eligible for the AWS Free Tier. You may choose a different instance type based on your requirements.
- **Terraform State**: Terraform maintains a state file to track the resources it manages. This file is crucial for applying updates and performing destroy operations.


## Use of Terraform

### Infrastructure Provisioning
Terraform automates the process of provisioning infrastructure by using configuration files to describe the desired state. This includes creating and managing virtual machines, databases, networks, and other resources across various cloud providers and on-premises environments.

### Benefits
1. **Consistency**: Ensures that infrastructure is created and managed in a consistent manner, reducing configuration drift.
2. **Reusability**: Allows for the reuse of configurations and modules, which improves efficiency and reduces duplication.
3. **Version Control**: Configuration files can be versioned and tracked, enabling collaboration and change management.
4. **State Management**: Keeps track of the state of infrastructure, allowing for accurate updates and rollbacks.
5. **Multi-Provider Support**: Provides a unified way to manage infrastructure across different providers using a single tool.


## Common Commands
1. `terraform init` - Initializes the working directory and downloads necessary provider plugins.
2. `terraform plan` - Creates an execution plan to show what actions will be taken without making changes.
3. `terraform apply` - Applies the changes required to reach the desired state defined in the configuration files.
4. `terraform destroy` - Removes all infrastructure managed by the current configuration.

