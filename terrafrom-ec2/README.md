
# **Creating an AWS EC2 Instance using Terraform**

### **Requirements:**
- [AWS EC2 instance](https://aws.amazon.com/ec2/)  
- [Key pair (for SSH access)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)  
- [AWS IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)  
- [AWS CLI configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)  

---

### **Step 1: AWS CLI Login**

To start, log in to AWS using the CLI and configure your credentials:
```bash
aws configure
```
- Enter your **Access Key**, **Secret Access Key**, and **Region**.
  - If you don't know them, refer to [AWS CLI Configuration Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
  - The region is essential for Terraform to know where to launch resources (e.g., `ap-south-1` for India).

---

### **Step 2: Create a User via AWS CLI**

Create an IAM user with the required permissions:
```bash
aws iam create-user --user-name omkara
```

#### **Assign Administrator Access to the User**:
```bash
aws iam attach-user-policy --user-name omkara --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

#### **Generate [Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) for Terraform Configuration**:
```bash
aws iam create-access-key --user-name omkara
```
This command will return an `AccessKeyId` and `SecretAccessKey`. **Copy them carefully** and save them in a secure location, as they are required for Terraform.

---

### **Step 3: Key Pair for EC2 Instance**

You will also need a **key pair** to access your EC2 instance via SSH. You can create this using the AWS Management Console or CLI:

The command creates an SSH key pair in AWS and saves the private key locally for EC2 instance access.

```bash
aws ec2 create-key-pair --key-name my-key-pair --query 'KeyMaterial' --output text > my-key-pair.pem
```

#### **Explanation**:
- **`--key-name my-key-pair`**: Creates a key pair named "my-key-pair."
- **`--query 'KeyMaterial'`**: Extracts only the private key content.
- **`--output text > my-key-pair.pem`**: Saves the private key to a file called `my-key-pair.pem`.

After this, run `chmod 400 my-key-pair.pem` to set secure permissions, and use this key to SSH into your EC2 instance.

---

### [**Terraform Configuration**](https://developer.hashicorp.com/terraform/language)

The Terraform configuration is made up of the following components:

1. **Provider**: Specifies the provider (AWS, in this case) and its region.
2. **Resource**: Defines the resource being created (an EC2 instance here).
3. **Output**: (Optional) Used to display information.
4. **Variable**: (Optional) Parameters to make the configuration dynamic.
5. **Data Sources**: (Optional) External information sources.

For EC2 creation, we'll focus on **provider** and **resource** blocks.

---

### **Terraform Configuration File**

Here’s a simple configuration file to create an EC2 instance:

```hcl
provider "aws" {
  alias  = "india"
  region = "ap-south-1"
}

resource "aws_instance" "jenkins-server" {
  ami             = "ami-0e53db6fd757e38c7" # Amazon Machine Image ID
  instance_type   = "t2.micro"              # EC2 instance type
  key_name        = "ec2-login"             # Name of the SSH key pair
}
```

### **Explanation of Parameters**:
- **Provider Block**:
  - **region**: Specifies the AWS region (e.g., `ap-south-1` for India).
- **Resource Block**:
  - **ami**: Amazon Machine Image ID, which defines the operating system and software for the instance.
  - **instance_type**: Defines the instance's computing power (e.g., `t2.micro` is a free-tier eligible, low-cost instance).
  - **key_name**: The name of the key pair used to SSH into the EC2 instance.

---

### **Terraform Commands:**

1. **[terraform init](https://developer.hashicorp.com/terraform/cli/commands/init)**
   - **Purpose**: Initializes the Terraform configuration and downloads the necessary provider plugins (in this case, AWS).
   - **Use**: Run this before any other Terraform command to set up your working directory.
   
   ```bash
   terraform init
   ```

2. **[terraform plan](https://developer.hashicorp.com/terraform/cli/commands/plan)**
   - **Purpose**: Runs a "dry run" to show you what resources will be created, modified, or destroyed.
   - **Use**: It is good practice to run this command before applying changes to verify the configuration.
   
   ```bash
   terraform plan
   ```

3. **[terraform apply](https://developer.hashicorp.com/terraform/cli/commands/apply)**
   - **Purpose**: Applies the Terraform configuration and asks for confirmation before creating resources.
   - **Use**: After reviewing the plan, run this command to create the EC2 instance. Enter "yes" when prompted.
   
   ```bash
   terraform apply
   ```

4. **[terraform destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy)**
   - **Purpose**: Destroys the resources managed by Terraform, including the EC2 instance.
   - **Use**: Be careful when using this command, as it will delete the resources.
   
   ```bash
   terraform destroy
   ```

---

### **Important Notes**:
- Since you are already logged in via the AWS CLI, you don't need to mention AWS credentials in the Terraform file.
- In cases where you want to manage resources without the CLI login, you can include the `AccessKey` and `SecretAccessKey` in the Terraform provider block, but this is not recommended due to security risks.

---

### **Conclusion**:
By following these steps, you can create an AWS EC2 instance using Terraform. The process involves logging into AWS via the CLI, setting up a user with the necessary permissions, configuring Terraform, and using key commands such as `terraform init`, `plan`, `apply`, and `destroy`.

These commands help you manage your infrastructure as code, providing a more streamlined and consistent approach to resource management in the cloud.

---

### **Official Documentation Links**:
- [Terraform Official Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS EC2 Documentation](https://aws.amazon.com/ec2/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
- [AWS IAM Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)

---

