# **Terraform Input Variables:**

---

## **Terraform Input Variables: Comprehensive Guide with Production Examples**

Terraform input variables enable you to define and customize the configuration values in your Terraform code. By using input variables, you can make your code flexible, reusable, and consistent across environments, which is especially critical in production setups.

---

## **Why Use Input Variables in Production?**

- **Consistency Across Environments**: You can use input variables to standardize configurations across multiple environments (e.g., development, staging, production) without modifying the main code.
- **Reusability of Modules**: You can pass different values to the same module, allowing you to reuse it across multiple configurations.
- **Security and Scalability**: Input variables enable you to avoid hardcoding sensitive information directly into the codebase. They also support scaling configurations, making them adaptable to changes without rewriting the code.

---

## **Ways to Define and Assign Input Variables in Terraform**

Terraform provides several methods to define and assign values to input variables, each useful in different scenarios. Here’s an in-depth look at each method, along with production examples.

---

## 1. **Defining Input Variables in `variables.tf`**

- **Explanation**: Input variables are typically defined in a `variables.tf` file, where you specify the variable name, type, and an optional default value.
- **Example**:
    
    ```hcl
    variable "instance_type" {
      description = "Type of AWS instance"
      type        = string
      default     = "t2.micro" # Optional default value
    }
    
    ```
    
- **Production Use Case**: Define variables that you frequently customize, such as instance types, region, or AMI IDs, for different environments.

---

## 2. **Using `terraform.tfvars` for Default Values**

- **Explanation**: Terraform automatically loads a `terraform.tfvars` file if it’s in the same directory as your configuration. This file allows you to assign default values to variables without modifying `variables.tf`.
- **Example** (`terraform.tfvars`):
    
    ```hcl
    instance_type = "t2.large"
    region = "us-east-1"
    
    ```
    
- **Production Use Case**: `terraform.tfvars` is ideal for setting default values that apply to all environments. You could define common instance types, regions, or tagging conventions that stay consistent across the project.

---

## 3. **Using `.auto.tfvars` Files for Automatic Loading**

- **Explanation**: Any file with the `.auto.tfvars` extension will also be loaded automatically by Terraform. This is useful for environment-specific files that you want to apply without needing to specify them in the command line.
- **Example** (`production.auto.tfvars`):
    
    ```hcl
    instance_type = "m5.large"
    region = "us-west-2"
    
    ```
    
- **Production Use Case**: For production deployments, use `.auto.tfvars` files like `production.auto.tfvars` to automatically apply environment-specific configurations. This helps avoid manual specification and ensures production settings are always applied.

---

## 4. **Environment Variables with the `TF_VAR_` Prefix**

- **Explanation**: Terraform will recognize environment variables prefixed with `TF_VAR_` and map them to input variables.
- **Setting Environment Variables**:
    
    ```bash
    export TF_VAR_instance_type="c5.large"
    export TF_VAR_region="us-east-1"
    
    ```
    
- **Production Use Case**: Useful for sensitive data (e.g., API keys, credentials) that shouldn’t be stored in files. Using environment variables is a secure way to manage sensitive values in automated CI/CD pipelines.

---

## 5. **Command-Line Overrides Using `var`**

- **Explanation**: The `var` flag allows you to set variable values directly in the command line, temporarily overriding other values.
- **Example**:
    
    ```bash
    terraform apply -var="instance_type=t3.micro"
    
    ```
    
- **Production Use Case**: Quick testing of values without modifying configuration files. However, this method is not recommended for production since it’s less reproducible and prone to human error.

---

## 6. **Specifying Custom Files with `var-file`**

- **Explanation**: If you use custom-named variable files (e.g., `staging.tfvars`), you need to specify them using the `var-file` flag.
- **Example**:
    
    ```bash
    terraform apply -var-file="staging.tfvars"
    
    ```
    
- **Production Use Case**: Use different files for various environments (e.g., `dev.tfvars`, `staging.tfvars`, `prod.tfvars`) and specify them as needed. This is essential in production to ensure correct environment-specific settings are used.

---

# **Understanding Variable Precedence (Order of Preference)**

Terraform follows a specific order to determine which variable value to use if the same variable is defined in multiple places. Higher-precedence methods override lower-precedence ones:

1. **Command-Line `var` Flag**: Highest priority, directly specified values take precedence.
2. **Command-Line `var-file` Flag**: Next in priority; files specified with `var-file` override all other sources except direct `var` flags.
3. **Environment Variables (`TF_VAR_` Prefix)**: Values set here override `.tfvars` and `.auto.tfvars` files.
4. **`.auto.tfvars` Files**: Automatically loaded without requiring explicit specification.
5. **`terraform.tfvars` File**: Automatically loaded if present, unless overridden by a higher-priority method.
6. **Default Values in `variables.tf`**: Lowest priority; used only if no other values are provided.

---

## **Example: Managing Different Environments in Production**

Imagine you have a multi-environment setup with different configurations for development, staging, and production. Here’s how you can manage variables for each environment.

1. **Define Variables in `variables.tf`**:
    
    ```hcl
    variable "instance_type" {
      description = "Instance type for AWS EC2"
      type        = string
      default     = "t2.micro" # Lowest-priority default
    }
    
    variable "region" {
      description = "AWS region"
      type        = string
    }
    
    ```
    
2. **Create Environment-Specific Files**:
    - **dev.tfvars**:
        
        ```hcl
        instance_type = "t2.small"
        region = "us-west-1"
        
        ```
        
    - **production.auto.tfvars**:
        
        ```hcl
        instance_type = "m5.large"
        region = "us-east-1"
        
        ```
        
3. **Applying Configurations in Production**:
    - To apply a staging setup:
        
        ```bash
        terraform apply -var-file="staging.tfvars"
        
        ```
        
    - For production, simply run:
        
        ```bash
        terraform apply
        
        ```
        
        - Here, Terraform automatically loads `production.auto.tfvars`, applying the production-specific configuration.
4. **Using Environment Variables in CI/CD Pipelines**:
    - Set up `TF_VAR_` environment variables in your CI/CD platform to avoid hardcoding sensitive data:
        
        ```bash
        export TF_VAR_access_key="YOUR_ACCESS_KEY"
        export TF_VAR_secret_key="YOUR_SECRET_KEY"
        
        ```
        
    - **CI/CD Example**:
        
        ```yaml
        # Example CI/CD pipeline configuration
        steps:
          - name: Deploy to Production
            env:
              TF_VAR_instance_type: "m5.large"
              TF_VAR_region: "us-east-1"
            script:
              - terraform apply
        
        ```
        
    - **Production Use Case**: Ensures production-specific settings are securely passed without hardcoding sensitive information, which is vital for automating production deployments.

---

# **Best Practices for Using Input Variables in Production**

1. **Use `.auto.tfvars` or `terraform.tfvars` for Environment Consistency**: Automatically loaded files like `terraform.tfvars` or `production.auto.tfvars` provide consistent configurations for specific environments.
2. **Environment Variables for Sensitive Data**: Manage sensitive data (e.g., passwords, API tokens) securely in environment variables prefixed with `TF_VAR_`.
3. **Isolate Environment Files**: Use separate `.tfvars` files for each environment and load them with `var-file` in CI/CD pipelines to enforce environment-specific values.
4. **Avoid `var` in Production**: Using `var` directly can lead to inconsistency and human error, so it’s best avoided in production settings.
5. **Always Set Default Values Carefully**: Define defaults only for non-sensitive, generic settings to ensure the base configuration is meaningful across environments.

By following these best practices and understanding Terraform’s variable precedence, you ensure a flexible, consistent, and secure infrastructure setup that’s tailored to production needs.

