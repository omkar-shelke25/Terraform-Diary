# Terraform Backends: Overview and Types

In Terraform, a **backend** is a mechanism for storing and managing the Terraform state file. The backend determines where the state file lives and how it can be accessed. There are two main types of backends: **enhanced backends** and **standard backends**.

---

## Enhanced Backends

Enhanced backends can both:

1. **Store the state file** - Store the Terraform state in a centralized location for shared access.
2. **Perform operations** - Execute commands like `terraform plan` and `terraform apply` directly on the backend.

The two enhanced backends are:

1. **Local backend** - Stores the state file locally, typically on the developer’s machine.
2. **Remote backend** - Stores the state file remotely, often used with **Terraform Cloud** or **Terraform Enterprise**.

## Example: Remote Backend with Terraform Cloud

When using the remote backend with **Terraform Cloud** or **Terraform Enterprise**, the setup allows teams to:

- Store Terraform state remotely and securely.
- Execute Terraform operations remotely in Terraform’s own environment.
- Manage access control, workflows, and logging.

**Sample Configuration**:

```hcl
terraform {
  backend "remote" {
    organization = "example-org"
    workspaces {
      name = "example-workspace"
    }
  }
}

```

In this setup:

- Terraform stores the state in Terraform Cloud, under the specified organization and workspace.
- Operations (`plan` and `apply`) are executed remotely by Terraform Cloud.

This approach is ideal for production environments where:

- Multiple team members need consistent access to the state.
- Secure storage and controlled access are priorities.
- Terraform execution should be managed and logged centrally.

---

## Standard Backends

Standard backends **only store the state file** and do not handle operations. This means they store the state centrally but rely on a local Terraform setup for running commands like `plan` and `apply`.

Common standard backends include:

- **AWS S3** - Stores the state in an S3 bucket.
- **Azure RM** - Stores the state in an Azure Blob Storage.
- **Google Cloud Storage (GCS)** - Stores the state in a GCS bucket.
- **Consul, etcd, HTTP** - Used for storing the state in distributed storage systems.

## Example: Standard Backend with AWS S3

The AWS S3 backend is commonly used for shared storage of Terraform state in AWS environments, often with DynamoDB for state locking to prevent conflicting operations.

**Sample Configuration**:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "my-lock-table"
    encrypt        = true
  }
}

```

In this configuration:

- The state is stored in an S3 bucket (`my-terraform-state-bucket`).
- A DynamoDB table (`my-lock-table`) is used to lock the state during operations, avoiding conflicts in a multi-user environment.
- `encrypt = true` ensures that the state file is encrypted for additional security.

This setup is effective in production because:

- The S3 bucket provides durable, accessible storage for the state file.
- DynamoDB locking ensures safe state handling in collaborative workflows.
- State access and modification are restricted by AWS Identity and Access Management (IAM) policies.

---

## Key Takeaways

1. **Enhanced backends** like **remote** (Terraform Cloud/Enterprise) can store the state and execute Terraform operations. Ideal for managed, secure production workflows.
2. **Standard backends** (S3, Azure RM, GCS) store the state but rely on the local backend for execution. They’re suitable for scenarios where you only need centralized state storage and handle execution locally.

For production:

- Use enhanced backends (e.g., Terraform Cloud) if you need managed, collaborative operations.
- Use standard backends (e.g., S3 with DynamoDB) if you need centralized, secure state storage but prefer handling execution locally.

