# What Backends Do

In Terraform, *backends* are responsible for handling and storing the **state** of your infrastructure. Here’s what this means and why it matters:

1. **State Storage**: Terraform keeps a record of the infrastructure it creates, which is called the "state". This record (state) is stored by the backend so that Terraform can understand the current setup of your infrastructure and track changes to it over time.
2. **Shared State Storage**: When multiple people are working on the same infrastructure, they all need to have access to the same state information. Imagine if each person had a different view of the infrastructure; it would be impossible to manage it consistently. The backend ensures that everyone is working with the latest version of the state data, allowing for *collaboration* and consistency.

## Production Use Example:

In a real-world scenario, companies often use **remote backends** (like Amazon S3, Azure Blob Storage, or Terraform Cloud) to store state files securely and in a central location. This allows everyone on the team to work with the same up-to-date state.

## State Locking

When someone applies changes in Terraform, **state locking** prevents other people from making changes at the same time. Without locking, multiple users could accidentally apply conflicting changes, leading to errors and inconsistencies in the infrastructure.

- **Why Locking Matters**: State locking is like reserving a seat when you start making changes to the infrastructure. While you hold the lock, no one else can modify the state, which reduces the risk of conflicts or misconfigurations.
- **Automatic Locking**: In remote backends like AWS S3 with DynamoDB (for locking), state locking happens automatically. Local backends don’t have locking features, making them riskier in multi-user environments.

## Production Use Example:

Consider a DevOps team working on infrastructure updates. If one engineer starts to update the infrastructure, the state gets locked. Other team members trying to make changes will get a message that the state is locked, preventing them from applying changes until the first engineer finishes, ensuring consistency.

## Operations in Terraform

"Operations" refer to the **actions that Terraform performs** on your infrastructure, such as:

- `terraform apply`: Creates or updates resources based on your configuration.
- `terraform destroy`: Deletes the resources managed by Terraform.

When you run these commands, Terraform makes API requests to your cloud provider to either create, read, update, or delete resources. *Not all commands in Terraform perform operations*, though. Some commands, like `terraform init` or `terraform plan`, just prepare or show changes without actually making them.

**Important**: Only two backends (local and remote) perform these operations directly on your infrastructure. This means that when you use a remote backend, it’s not just storing state—it can also perform apply/destroy actions in the cloud.

## Production Use Example:

If you’re working in a production environment and you want to roll out updates (apply changes) to infrastructure resources like servers, networks, or databases, you would use `terraform apply`. Your backend, if configured for remote operations (like with Terraform Cloud), can directly apply these changes without needing a local machine to handle them.

## Summary

- **Backends** store Terraform’s state, helping keep everyone’s view of the infrastructure consistent.
- **State Locking** prevents two people from making conflicting changes at the same time, ensuring reliable updates.
- **Operations** in Terraform (`apply`, `destroy`) are the actual actions on infrastructure. Only specific backends (local and remote) can perform these directly on the infrastructure.

In production, teams often use a remote backend with state locking and shared state storage, such as S3 with DynamoDB for locking, allowing seamless collaboration and consistent changes across the team.