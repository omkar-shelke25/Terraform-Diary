# Terraform depends_on Meta-Argument: Complete Notes

## Overview

The `depends_on` meta-argument in Terraform is used to explicitly declare dependencies between resources or modules. This ensures that certain resources are created or modified only after others have been completed. This is particularly useful when the default dependency management in Terraform is not sufficient.

## Key Points

1. **Purpose**:
    - Ensures specific resources or modules are created before others.
    - Helps manage complex dependencies that may not be inferred automatically by Terraform.
2. **Syntax**:
    - The `depends_on` argument must be a **list** of references to other resources or child modules.
    - It must be enclosed in square brackets `[]` and separated by commas if multiple items are included.
3. **Usage Context**:
    - **Resource Blocks**: Used to declare that a resource should depend on other resources.
    - **Module Blocks**: Used to declare that a module should depend on other resources or modules.
4. **Limitations**:
    - All referenced resources or modules must be defined in the **same module** where the `depends_on` is being used. You cannot reference resources from different modules.
    - The `depends_on` argument is optional; if not specified, Terraform automatically infers dependencies based on resource references.

### Examples

**Example 1: Using `depends_on` in a Resource Block**

```hcl
resource "aws_security_group" "example" {
  name        = "example_sg"
  description = "Example security group"
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  depends_on = [
    aws_security_group.example  # Ensures the security group is created first
  ]
}

```

In this example, the AWS instance will only be created after the security group is successfully created.

**Example 2: Using `depends_on` in a Module Block**

```hcl
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

module "my_module" {
  source = "./my_module_directory"

  depends_on = [
    aws_vpc.example  # Ensures the VPC is created before the module is executed
  ]
}

```

In this example, the module `my_module` will be executed only after the VPC resource is created.

## Best Practices

- **Use Sparingly**: Rely on Terraform's automatic dependency management whenever possible. Use `depends_on` only when necessary.
- **Keep Dependencies Clear**: Clearly document the dependencies to maintain readability and understanding of your Terraform code.
- **Group Dependencies**: If multiple resources depend on the same resource, group them in a single `depends_on` list.

# Summary

The `depends_on` meta-argument is a powerful tool in Terraform for managing dependencies explicitly. By using it correctly, you can ensure that your infrastructure is created in the desired order, leading to a more reliable deployment process. Remember to keep your references within the same module and to use the list format to specify dependencies.