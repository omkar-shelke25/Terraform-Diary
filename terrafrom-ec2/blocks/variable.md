### Terraform Variable Block Notes

#### 1. **What is a Variable Block?**
In Terraform, a **variable block** is used to define input values that can be passed into your Terraform configuration. Variables make your code more flexible and reusable by allowing different values to be supplied without changing the core configuration.

#### 2. **Basic Syntax of a Variable Block**
The variable block defines:
- **Name**: A unique identifier for the variable.
- **Type (optional)**: Specifies the data type (e.g., string, list, map).
- **Default (optional)**: A default value for the variable.
- **Description (optional)**: A human-readable explanation of the variable.

```hcl
variable "<VARIABLE_NAME>" {
  type        = <TYPE>
  default     = <DEFAULT_VALUE>
  description = "<DESCRIPTION>"
}
```

#### 3. **Example of a Variable Block**
Let’s define a variable for the instance type of an AWS EC2 instance.

```hcl
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of EC2 instance to create"
}
```
- **instance_type**: The name of the variable.
- **type**: The variable is expected to be a string.
- **default**: If no value is provided, it will use `t2.micro`.
- **description**: A short explanation of what the variable is for.

#### 4. **Types of Variables**
- **string**: A single text value (e.g., `"t2.micro"`).
- **number**: A numerical value (e.g., `10`).
- **bool**: A boolean value (`true` or `false`).
- **list**: A list of values (e.g., `["a", "b", "c"]`).
- **map**: A set of key-value pairs (e.g., `{key1 = "value1", key2 = "value2"}`).

Example for a **list** variable:

```hcl
variable "availability_zones" {
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]
  description = "List of availability zones"
}
```

#### 5. **Referencing Variables**
Once a variable is defined, you can reference it in your Terraform code using `${var.<VARIABLE_NAME>}`.

Example:

```hcl
resource "aws_instance" "example" {
  instance_type = var.instance_type
  ami           = "ami-0c55b159cbfafe1f0"
}
```
Here, the `instance_type` is using the value of the `instance_type` variable defined earlier.

#### 6. **Variable Default vs. Input**
You can supply a value for a variable through:
- **Default value** in the variable block itself (optional).
- **Command line** when running `terraform apply` or `terraform plan`.
- **Variable files (`.tfvars`)**: You can create a separate file to store variable values.

Example of a `.tfvars` file:

```hcl
instance_type = "t2.large"
```

You can pass this file during the Terraform run:

```bash
terraform apply -var-file="variables.tfvars"
```

#### 7. **Using Variables with Modules**
Variables are essential when creating reusable modules. You can pass different values into a module using input variables, allowing you to use the same module with different configurations.

Example:

```hcl
module "web" {
  source        = "./web_module"
  instance_type = var.instance_type
}
```

#### 8. **Best Practices for Variables**
- **Use Descriptive Names**: Clearly name variables to reflect their purpose.
- **Default Values**: Always use default values when possible to simplify deployment.
- **Variable Types**: Always specify variable types for clarity and to prevent mistakes.
- **Separate Variables File**: Store your variable values in a `.tfvars` file to keep your code clean.

#### 9. **Common Interview Questions Related to Variables**
- What is a variable block in Terraform, and why is it used?
- How can you pass variables into a Terraform configuration?
- What is the purpose of a `.tfvars` file in Terraform?
- How do you define and reference a list or map variable?

