# Custom validation

Custom validation in Terraform is a way to ensure that input variables meet specific conditions or constraints before being applied. It helps in enforcing custom rules and preventing misconfigurations by validating input data. Here’s a comprehensive breakdown of how to use and understand custom validations in Terraform:
---

### 1. **Overview of Custom Validation in Terraform**

- Custom validation allows you to set specific constraints on input variables, ensuring that users provide valid values according to defined rules.
- Terraform uses the `validation` block within a `variable` block to enforce these constraints.
- This feature helps in reducing errors, especially in complex infrastructure setups, by catching potential misconfigurations early.

### 2. **Basic Structure of Custom Validation**

- The `validation` block is defined inside the `variable` block.
- A typical `validation` block consists of:
    - **condition**: An expression that evaluates to `true` or `false`. If `false`, Terraform will throw an error.
    - **error_message**: A custom error message displayed if the condition fails.

Here’s a simple syntax:

```hcl
variable "example_variable" {
  type = string

  validation {
    condition     = <expression>
    error_message = "Your custom error message here."
  }
}

```

### 3. **How `condition` and `error_message` Work**

- **condition**: This is the core of the custom validation. It contains an expression that evaluates the input.
    - If the condition is `true`, Terraform accepts the input value.
    - If `false`, Terraform returns the specified `error_message`.
- **error_message**: Used to guide users when the input value doesn’t meet the specified criteria.
    - It’s important to make this message descriptive to inform users what went wrong and possibly how to fix it.

### 4. **Practical Examples of Custom Validation**

### Example 1: Enforcing a String Length Limit

- Imagine you want to limit an input string to a maximum of 10 characters:

```hcl
variable "username" {
  type = string

  validation {
    condition     = length(var.username) <= 10
    error_message = "The 'username' variable must be 10 characters or less."
  }
}

```

### Example 2: Validating Number Ranges

- Let’s say you want to restrict an integer input to a range between 1 and 10:

```hcl
variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "The 'instance_count' must be between 1 and 10."
  }
}

```

### Example 3: Restricting String Values to a Set of Options

- If you want to ensure a variable only accepts certain values, use `contains()` and `list` functions:

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "The 'environment' variable must be one of 'dev', 'stage', or 'prod'."
  }
}

```

### Example 4: Validating CIDR Format

- Suppose you want to ensure an input is a valid CIDR block:

```hcl
variable "subnet_cidr" {
  type = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.subnet_cidr))
    error_message = "The 'subnet_cidr' must be a valid CIDR block, like '192.168.0.0/16'."
  }
}

```

### 5. **Advanced Validation Techniques**

### Using `can` for Error Handling in Validation

- The `can()` function helps prevent Terraform from failing due to invalid expressions by testing if an expression can be evaluated without errors.
- Example:

```hcl
variable "instance_type" {
  type = string

  validation {
    condition     = can(length(var.instance_type) > 0)
    error_message = "The 'instance_type' must be a non-empty string."
  }
}

```

### Combining Multiple Conditions

- You can combine conditions using logical operators (`&&`, `||`) to create complex validations.
- Example: Check if a number is either between 1-10 or between 20-30.

```hcl
variable "number" {
  type = number

  validation {
    condition     = (var.number >= 1 && var.number <= 10) || (var.number >= 20 && var.number <= 30)
    error_message = "The 'number' must be between 1-10 or 20-30."
  }
}

```

### 6. **When to Use Custom Validation**

- Use custom validation when you need:
    - Specific value constraints not achievable with only the `type` attribute.
    - Rules based on the context of your infrastructure (e.g., only certain regions, specific CIDR formats).
    - To avoid common user mistakes in providing input variables.

### 7. **Limitations of Custom Validation**

- Custom validation cannot be used for enforcing relational constraints between two different variables directly. You may need workarounds or consider using Terraform modules if the constraints are too complex.
- It currently only works within the scope of the `variable` block, so custom validations for resources or outputs are not supported.

### 8. **Best Practices for Custom Validation**

- **Use Descriptive Error Messages**: Make sure your error messages clearly explain what went wrong and, if possible, suggest how to fix it.
- **Test Validations**: Test each validation thoroughly to ensure it works as expected, especially for complex conditions.
- **Keep Conditions Simple**: Overly complex validation conditions can be harder to understand and maintain.
- **Consider Usability**: Think about how the validation might affect users. For example, don’t enforce overly restrictive rules unless necessary.

### 9. **Real-World Example**

Suppose you are setting up a variable for an AWS instance type with specific instance types allowed only in production:

```hcl
variable "instance_type" {
  type = string

  validation {
    condition = (
      (var.environment == "prod" && contains(["t2.large", "t3.large"], var.instance_type)) ||
      (var.environment != "prod" && contains(["t2.micro", "t3.micro"], var.instance_type))
    )
    error_message = "In 'prod' environment, 'instance_type' must be 't2.large' or 't3.large'. Otherwise, use 't2.micro' or 't3.micro'."
  }
}

```

### Summary

Custom validation in Terraform is a powerful feature that enforces specific rules on variables to prevent misconfiguration. By defining `condition` and `error_message` in the `validation` block, you can ensure inputs meet the required constraints, making your infrastructure more robust and resilient.