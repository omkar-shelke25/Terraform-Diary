

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




