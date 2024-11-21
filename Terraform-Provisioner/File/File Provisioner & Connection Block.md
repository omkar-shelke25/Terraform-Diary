# **File Provisioner & Connection Block**

---

## **File Provisioner & Connection Block**

Provisioners in Terraform help execute scripts or commands on a resource after it is created. One of the most common provisioners is the **File Provisioner**, which transfers files or directories from your local machine to the target resource, such as an EC2 instance.

### **1. Connection Block**

The **connection block** is essential for provisioners like file and remote-exec, as it defines how Terraform connects to the target resource.

- **Syntax for Connection Block:**
    
    ```hcl
    connection {
      type     = "ssh" # The connection type, typically "ssh" for Linux instances.
      host     = self.public_ip # The IP address of the EC2 instance. Here, `self` refers to the parent resource.
      user     = "ec2-user" # The username to log in.
      password = "" # Password, if applicable (not used in this case).
      private_key = file("private-key/terraform-key.pem") # Path to the private key file for SSH access.
    }
    ```
    
- **Key Points:**
    - The **`self` object** refers to the parent resource (in this case, the EC2 instance).
    - Using `self` avoids dependency cycles. For example, `self.public_ip` fetches the public IP of the EC2 instance created by the resource block.

---

### **2. Provisioner Types**

Provisioners allow you to manage configuration beyond the typical infrastructure setup. Common use cases include copying files, installing software, and running configuration scripts.

### **Creation-Time Provisioners**

- **When They Run:** Creation-time provisioners run **only when the resource is being created**.
- **Default Behavior:** If a provisioner fails during resource creation:
    - The resource is marked as **tainted**.
    - Terraform will plan to destroy and recreate the resource during the next `terraform apply`.

### **on_failure Attribute**

This attribute defines what happens if a provisioner fails.

- **Values:**
    - `continue`: Ignore the error and proceed with resource creation/destruction.
    - `fail` (default): Stop applying and mark the resource as tainted.

---

### **3. Examples of File Provisioners**

The **file** provisioner copies files or directories to the target resource.

- **Copying a Single File:**
    
    ```hcl
    provisioner "file" {
      source      = "apps/file-copy.html" # Local file path.
      destination = "/tmp/file-copy.html" # Remote destination on the EC2 instance.
    }
    ```
    
- **Copying File Content (String):**
    
    ```hcl
    provisioner "file" {
      content     = "ami used: ${self.ami}" # Passes a string instead of a file.
      destination = "/tmp/file.log" # Remote destination for the string content.
    }
    ```
    
- **Copying a Folder:**
    
    ```hcl
    provisioner "file" {
      source      = "apps/app1" # Local folder path.
      destination = "/tmp" # Copies the entire folder to the destination.
    }
    ```
    
- **Copying Folder Contents:**
    
    ```hcl
    provisioner "file" {
      source      = "apps/app2/" # Adding "/" copies only the folder contents, not the folder itself.
      destination = "/tmp"
    }
    ```
    

---

### **4. Steps to Test Provisioners**

Follow these commands to validate and apply Terraform configuration:

1. **Initialize Terraform:**
    
    ```bash
    terraform init
    ```
    
2. **Validate Configuration:**
    
    ```bash
    terraform validate
    ```
    
3. **Format Code:**
    
    ```bash
    terraform fmt
    ```
    
4. **Plan Resources:**
    
    ```bash
    terraform plan
    ```
    
5. **Apply Changes:**
    
    ```bash
    terraform apply -auto-approve
    ```
    
6. **Verify File Transfers:**
    - Log in to the EC2 instance using SSH:
        
        ```bash
        chmod 400 private-key/terraform-key.pem
        ssh -i private-key/terraform-key.pem ec2-user@<PUBLIC_IP>
        ```
        
    - Check the `/tmp` directory for copied files:
        
        ```bash
        cd /tmp
        ls -lrta
        ```
        
7. **Clean Up Resources:**
    
    ```bash
    terraform destroy -auto-approve
    rm -rf terraform.tfstate*
    ```
    

---

### **5. Handling Provisioner Failures**

### **Scenario 1: Default Behavior (on_failure not specified or fail)**

- If a provisioner fails (e.g., trying to copy to a restricted directory like `/var/www/html`):
    - Terraform stops applying changes.
    - The resource is marked as **tainted** in `terraform.tfstate`.
    - You will need to address the issue before re-applying.
- **Example:**
    
    ```hcl
    provisioner "file" {
      source      = "apps/file-copy.html"
      destination = "/var/www/html/file-copy.html" # This will fail due to lack of permissions.
    }
    ```
    

### **Scenario 2: Use on_failure = "continue"**

- If you want Terraform to proceed despite the failure:
    
    ```hcl
    provisioner "file" {
      source      = "apps/file-copy.html"
      destination = "/var/www/html/file-copy.html"
      on_failure  = "continue" # Ignore errors and continue resource creation.
    }
    ```
    
- **Verification:**
    - Check the `terraform.tfstate` file for `"status": "tainted"` after a failed provisioner.

---

### **6. Key Concepts to Remember**

1. **`self` Object:** Represents the resource within which the provisioner is defined. Useful for accessing attributes like `self.public_ip`.
2. **Provisioner Failures:** Resources are marked as tainted on failure by default, but this can be changed using `on_failure`.
3. **Provisioner Execution:** Provisioners run only during resource creation unless explicitly configured otherwise.
4. **File Provisioner Behavior:**
    - A trailing `/` in the source path copies the **contents** of a folder, not the folder itself.
    - Files and folders can be copied to the remote instance for configuration or debugging.

---

By following this structured approach, you can effectively use file provisioners, connection blocks, and handle failures gracefully in Terraform projects.

