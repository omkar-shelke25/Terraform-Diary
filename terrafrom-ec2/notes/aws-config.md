

## Steps to Log in to AWS via AWS CLI

#### 1. **Install AWS CLI**
If you haven't installed the AWS CLI, follow the installation guide from the official AWS documentation: [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

#### 2. **Create an IAM User**
Before configuring the AWS CLI, you need an IAM user. If the user does not already exist, you can create one using the following command:

```bash
aws iam create-user --user-name Bob
```
This creates a new IAM user named "Bob."

#### 3. **List IAM Users**
To confirm that the user "Bob" has been created, list all IAM users:

```bash
aws iam list-users
```

You should see "Bob" listed among the users.

#### 4. **Create an Access Key for the IAM User**
To enable programmatic access to AWS for this IAM user, you need to create an access key. Use the following command:

```bash
aws iam create-access-key --user-name Bob
```

Upon successful execution, you will receive the **AccessKeyId** and **SecretAccessKey** for the user. For example:

```json
{
  "AccessKey": {
    "UserName": "Bob",
    "Status": "Active",
    "CreateDate": "2015-03-09T18:39:23.411Z",
    "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYzEXAMPLEKEY",
    "AccessKeyId": "AKIAIOSFODNN7EXAMPLE"
  }
}
```

**Important:** The **SecretAccessKey** is only available at the time of creation, so store it securely. If lost, you will need to generate a new key.

#### 5. **Configure AWS CLI**
After receiving the access key, configure AWS CLI with the access key, region, and output format. Run:

```bash
aws configure
```

You will be prompted to enter:

- **AWS Access Key ID**: Found in the output of the `create-access-key` command.
- **AWS Secret Access Key**: Found in the same output.
- **Default region name**: e.g., `us-west-2`.
- **Default output format**: `json`, `text`, or `table`.

#### 6. **Verify Configuration**
Run the following command to verify your AWS CLI configuration:

```bash
aws s3 ls
```

If the configuration is correct, you should see a list of your S3 buckets.

#### 7. **List Access Keys for a User**
To check access keys associated with the user, run:

```bash
aws iam list-access-keys --user-name Bob
```

This will list all access keys (both active and inactive) for the user.

Example output:

```json
{
  "AccessKeyMetadata": [
    {
      "UserName": "Bob",
      "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
      "Status": "Active",
      "CreateDate": "2015-03-09T18:39:23.411Z"
    }
  ]
}
```

---

### Security Best Practices
- **Secure Access Keys**: The **SecretAccessKey** is shown only once. Store it securely and never hard-code it in your application.
- **Rotate Access Keys**: Regularly rotate access keys to mitigate security risks.
- **Least Privilege Principle**: Assign only the permissions necessary for the user to perform their job.
- **Delete Unused Keys**: Periodically review and delete unused or inactive access keys.
- **Use IAM Policies**: Apply restrictive IAM policies to manage access to AWS services.

--- 

