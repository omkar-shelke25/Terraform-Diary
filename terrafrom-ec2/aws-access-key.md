

# Access Keys for AWS IAM Users and Root Users

- **Definition**: Access keys are long-term credentials for an IAM user or the AWS account root user. They can be used to sign programmatic requests to the AWS CLI or AWS API (directly or using the AWS SDK).

## Access Key Components:
- Access keys consist of two parts:
  1. **Access Key ID**: (Example: AKIAIOSFODNN7EXAMPLE)
  2. **Secret Access Key**: (Example: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY)

Both the **Access Key ID** and **Secret Access Key** must be used together to authenticate requests.

## Security Guidelines:
- When creating an access key pair, save both the **Access Key ID** and **Secret Access Key** in a secure location.
- **Important**: The secret access key is available only when it is first created. If it is lost, the access key must be deleted and a new one must be created.

## Limitations:
- You can have a maximum of **two access keys per user**.


## Important Information About Access Keys:
- When you create an access key pair, **save the access key ID and secret access key in a secure location**.
- The **secret access key** is available **only at the time you create it**.
- **If you lose your secret access key**, you must delete the access key and create a new one.


##

Here are the notes based on the provided raw information:

---

# Creating an Access Key for an IAM User

## Command to Create an Access Key:
To create an access key (access key ID and secret access key) for a specific IAM user, use the following command:

```bash
aws iam create-access-key \
    --user-name Bob
```

This example creates an access key for the IAM user named **Bob**.

## Output Example:
Upon successful execution, the output includes details about the newly created access key, as shown below:

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

## Important Security Note:
- The **Secret Access Key** is available **only at the time of creation**.
- You must **store the secret access key in a secure location**. If it is lost, it cannot be recovered, and you will need to create a new access key.
- If the IAM user "Bob" does not exist and you run the `aws iam create-access-key --user-name Bob` command, AWS will return an error. The error will indicate that the specified user does not exist. Here's an example of what the error might look like:

```bash
An error occurred (NoSuchEntity) when calling the CreateAccessKey operation: The user with name Bob cannot be found.
```
- To avoid this error, you must first ensure that the IAM user "Bob" exists. You can do this by listing the users or creating the user if they don't already exist.

### Command to list IAM users:
```bash
aws iam list-users
```

### Command to create an IAM user:
If "Bob" does not exist, you can create the user with this command:
```bash
aws iam create-user --user-name Bob
```
After the user is created, you can then proceed with creating the access key.





