# **Handling Provisioner Failures in Terraform**

Provisioner failures can affect the execution of your Terraform configurations in significant ways. Terraform provides mechanisms to control how failures are handled, helping you determine the appropriate behavior for your specific use case.

---

## **Scenario 1: Default Behavior (`on_failure` not specified or set to `fail`)**

By default, if a provisioner fails during resource creation, Terraform halts further execution. This behavior ensures that any misconfiguration or unanticipated issue is brought to attention and prevents resources from being created in a potentially unstable state.

- **Key Points:**
    - The `on_failure` attribute is not specified or defaults to `fail`.
    - A failed provisioner marks the resource as **tainted**.
    - Terraform will attempt to destroy and recreate the tainted resource during the next `terraform apply`.
- **Example:**
    
    ```hcl
    resource "aws_instance" "example" {
      ami           = "ami-12345678"
      instance_type = "t2.micro"
    
      # File provisioner to copy a file to a restricted directory
      provisioner "file" {
        source      = "apps/file-copy.html"
        destination = "/var/www/html/file-copy.html" # This will fail without sudo permissions
      }
    
      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("private-key/terraform-key.pem")
        host        = self.public_ip
      }
    }
    
    ```
    
    - **Outcome:**
        - The provisioner fails because the `ec2-user` does not have permissions to write to `/var/www/html`.
        - Terraform halts execution and marks the resource as **tainted**.
        - You must fix the issue (e.g., update permissions or use `sudo`) before running `terraform apply` again.
- **Verification:**
    - Open the `terraform.tfstate` file after failure:
        - Look for `"status": "tainted"` in the resource entry. This indicates the resource is considered incomplete and will be recreated on the next `terraform apply`.

---

## **Scenario 2: Using `on_failure = "continue"`**

To allow Terraform to continue resource creation even if a provisioner fails, you can set `on_failure = "continue"`. This is useful in situations where the provisioner's failure is not critical to the overall functionality or can be resolved manually later.

- **Key Points:**
    - By setting `on_failure = "continue"`, Terraform ignores the provisioner's error.
    - The resource is still created, but the state file may show it as **tainted**.
    - This setting is useful when failures are recoverable or should not block resource creation.
- **Example:**
    
    ```hcl
    
    resource "aws_instance" "example" {
      ami           = "ami-12345678"
      instance_type = "t2.micro"
    
      # File provisioner with on_failure set to continue
      provisioner "file" {
        source      = "apps/file-copy.html"
        destination = "/var/www/html/file-copy.html"
        on_failure  = "continue" # Allow Terraform to proceed even if this step fails.
      }
    
      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("private-key/terraform-key.pem")
        host        = self.public_ip
      }
    }
    ```
    
    - **Outcome:**
        - The provisioner fails (e.g., due to lack of permissions).
        - Terraform continues to create the resource without halting.
        - The resource is created but marked as **tainted** in the state file.
- **Verification:**
    - Check the `terraform.tfstate` file:
        - Look for `"status": "tainted"` in the resource entry. This indicates that although the resource was created, the provisioner failed during execution.

---

## **Comparison: Default Behavior vs. `on_failure = "continue"`**

| **Aspect** | **Default Behavior (`fail`)** | **`on_failure = "continue"`** |
| --- | --- | --- |
| **Execution on failure** | Stops and halts the Terraform run. | Continues resource creation. |
| **Resource status** | Resource is marked as **tainted**. | Resource is created and **tainted**. |
| **Use case** | Critical provisioner actions (e.g., bootstrapping). | Non-critical actions or manual recovery. |
| **Example application** | Copying essential setup files. | Copying optional or recoverable files. |

---

## **Practical Testing of Failure Handling**

1. **Without `on_failure`:**
    - Try copying a file to `/var/www/html` without sufficient permissions.
    - Expected result: Terraform halts and marks the resource as **tainted**.
    
    ```hcl
    hcl
    Copy code
    provisioner "file" {
      source      = "apps/file-copy.html"
      destination = "/var/www/html/file-copy.html"
    }
    
    ```
    
    - Verification:
        - Check the `terraform.tfstate` file for `"status": "tainted"`.
2. **With `on_failure = "continue"`:**
    - Add `on_failure = "continue"` to the provisioner block.
    - Expected result: Terraform continues execution, and the resource is created but marked as **tainted**.
    
    ```hcl
    hcl
    Copy code
    provisioner "file" {
      source      = "apps/file-copy.html"
      destination = "/var/www/html/file-copy.html"
      on_failure  = "continue"
    }
    ```
    
    - Verification:
        - Login to the EC2 instance and manually verify that the file is not copied due to the failure.

---

## **Key Takeaways**

1. **Default Behavior (`fail`)**:
    - Ensures that critical issues are caught early.
    - Protects resources from being left in a semi-configured state.
2. **`on_failure = "continue"`**:
    - Allows flexibility for non-critical tasks.
    - Useful for troubleshooting without blocking the entire Terraform execution.
3. **Tainting**:
    - Failed provisioners lead to a **tainted** resource status.
    - Terraform will recreate tainted resources during the next `terraform apply`.
4. **Practical Application**:
    - Always test provisioner blocks thoroughly.
    - Use `on_failure` only when failure does not impact the critical functionality of your resource.