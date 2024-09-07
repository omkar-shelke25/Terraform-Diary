
# Steps to Log in to AWS via AWS CLI

## 1. **Install AWS CLI**
If you haven't installed the AWS CLI, you can download and install it using the instructions from the official AWS documentation:
- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## 2. **Configure AWS CLI**
After installing the AWS CLI, you need to configure it by providing your access credentials.

Run the following command in your terminal or command prompt:

```bash
aws configure
```

You will be prompted to enter the following information:

- **AWS Access Key ID**: You can retrieve this from your AWS Management Console.
- **AWS Secret Access Key**: Provided when creating the access key.
- **Default region name**: (Optional) The AWS region you'd like to use, such as `us-west-2` or `us-east-1`.
- **Default output format**: (Optional) Choose a format for output like `json`, `text`, or `table`.
![aws-config](image.png)

## Example:
```bash
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```
## 3. **Verify Configuration**
To ensure the configuration is correct, you can run a simple command like listing your S3 buckets:

```bash
aws s3 ls
```

If you have access, it will list your S3 buckets; otherwise, you'll see an error if the credentials are incorrect or permissions are insufficient.

## Additional Notes:
- The credentials you use with `aws configure` are stored in the `~/.aws/credentials` file for future use.
- You can update your configuration anytime by running `aws configure` again or manually editing the credentials file.
  
This will authenticate you to AWS using the CLI, allowing you to make API requests and manage your resources programmatically.



## `aws iam list-access-keys` Command

- **Description**: Lists access keys for an IAM user.
- **Syntax**: 
  ```bash
  aws iam list-access-keys [--user-name <username>]
  ```
  - **`--user-name <username>`**: (Optional) Specify the IAM user; if omitted, lists access keys for the current IAM user.

- **Example Commands**:
  - List access keys for the current IAM user:
    ```bash
    aws iam list-access-keys
    ```
  - List access keys for a specific IAM user:
    ```bash
    aws iam list-access-keys --user-name Bob
    ```

- **Example Output**:
  ```json
  {
      "AccessKeyMetadata": [
          {
              "UserName": "Bob",
              "AccessKeyId": "AKIAIOSFODNN7EXAMPLE",
              "Status": "Active",
              "CreateDate": "2015-03-09T18:39:23.411Z"
          },
          {
              "UserName": "Bob",
              "AccessKeyId": "AKIAIOSFODNN7ANOTHER",
              "Status": "Inactive",
              "CreateDate": "2016-05-15T10:12:34.567Z"
          }
      ]
  }
  ```
  ![list]](image-1.png)

- **Output Fields**:
  - **`UserName`**: IAM user’s name.
  - **`AccessKeyId`**: Unique identifier of the access key.
  - **`Status`**: Key status (`Active` or `Inactive`).
  - **`CreateDate`**: Date and time when the key was created.

- **Permissions Required**: `iam:ListAccessKeys` action must be allowed in the IAM policy.

- **Common Error**: `AccessDenied` if permissions are insufficient.

- **Security Note**: Handle access keys securely and follow best practices.

