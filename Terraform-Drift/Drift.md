# Terraform Drift: Deep Dive

---

## 1. **What is Terraform Drift?**

In Terraform, **drift** occurs when the actual state of infrastructure resources differs from the state defined in Terraform’s state file. The state file (typically `terraform.tfstate`) is a critical component in Terraform, storing the exact configuration of managed infrastructure. When any changes are made to resources outside of Terraform (like via a cloud provider’s console or CLI), it leads to a discrepancy, or “drift,” between what Terraform thinks exists and the real infrastructure.

## 2. **Why Does Drift Happen?**

Drift usually happens in the following situations:

- **Manual Changes:** Someone modifies resources directly through the cloud provider’s interface or command-line tools, bypassing Terraform.
- **External Automation:** Automated systems (like a CI/CD pipeline or monitoring service) may change configurations dynamically, which Terraform doesn’t track.
- **Resource Defaults:** Some resources may update automatically, like security group rules or autoscaling configurations, due to default settings or internal processes within cloud providers.

These changes create an inconsistency with Terraform’s state file, meaning Terraform is unaware of the real, current state of the infrastructure.

## 3. **Why Beginners Find Drift Confusing**

Many new users find drift confusing because:

- **Terraform’s “Single Source of Truth” Concept**: Beginners often assume that the state file is a perfect reflection of the infrastructure. They may not understand that changes outside Terraform can desynchronize the state, breaking this assumption.
- **Terraform’s Abstraction**: Terraform abstracts infrastructure as code, so users don’t directly interact with the infrastructure. When drift occurs, it introduces an invisible change that doesn’t align with the code they see.
- **Unexpected Results from `terraform plan`**: When drift exists, `terraform plan` might show actions to “correct” infrastructure, which can be surprising for beginners if they don’t realize the resources were modified externally.
- **Terminology**: Terms like “state file,” “drift,” and “reconciliation” are new concepts for beginners and may lead to misunderstandings, especially if they aren’t yet familiar with state management.

## 4. **How Terraform Detects and Handles Drift**

Terraform doesn’t automatically detect drift. Instead, it has mechanisms to help identify and address it:

- **`terraform plan`**: This command checks for differences between the current configuration and the actual infrastructure state. If drift is detected, it suggests changes required to bring resources back in sync with the configuration.
- **`terraform apply`**: When drift is detected, `terraform apply` will try to reconcile resources by applying necessary modifications to match the configuration. This action brings the infrastructure back to the state defined in the configuration files.
- **`terraform refresh` (Deprecated)**: Previously, `terraform refresh` was used to update the state file with the latest information from the infrastructure, but it is deprecated. The same function is now part of `terraform plan`, which will refresh the state automatically as it checks for drift.

## 5. **How to Manage and Resolve Drift**

Managing drift effectively is crucial to keeping infrastructure stable and predictable. Here are steps and best practices:

- **Detect Drift with `terraform plan`**: Regularly run `terraform plan` to identify any drift. This command will highlight changes Terraform would make to align the infrastructure with the configuration.
- **Reconcile Drift with `terraform apply`**: Once you’ve identified drift, run `terraform apply` to reconcile the state, if desired. Terraform will make the necessary changes to ensure the actual infrastructure matches the state file.
- **Avoid Manual Changes**: Minimize making changes directly in the cloud provider’s console or CLI for resources managed by Terraform. Instead, all changes should ideally be made within the Terraform configuration files.
- **Use `terraform import` for Existing Resources**: If you need to manage an existing resource created outside Terraform, use the `terraform import` command to bring it under Terraform’s management, which adds the resource to the state file without changing it.
- **Understand `terraform state` Commands**: Terraform’s `state` commands allow you to interact with the state file directly. For instance:
    - `terraform state list` - Lists resources tracked in the state file.
    - `terraform state show <resource>` - Displays detailed information about a particular resource in the state.
    - `terraform state rm <resource>` - Removes a resource from the state file without affecting the actual resource, useful for removing resources you want to stop managing with Terraform.

## 6. **Example Scenarios of Drift and Solutions**

- **Scenario 1: Manual Update to Security Group**
    
    Suppose you add an extra security group rule directly through the AWS Console. When you run `terraform plan`, Terraform detects this drift and will either suggest removing that rule (if it’s not in the configuration) or show an error. To resolve this:
    
    - Decide if you want to add that rule to the Terraform configuration to keep it.
    - Alternatively, remove it manually in AWS or allow Terraform to remove it through `terraform apply`.
- **Scenario 2: Autoscaling Updates by AWS**
    
    Let’s say AWS automatically updates the size of an autoscaling group. When you run `terraform plan`, Terraform detects the drift and will propose adjusting it back to the original configuration. To resolve this:
    
    - Add the new configuration to Terraform files if you want to keep it.
    - Otherwise, apply the plan to reset it to the defined state.

## 7. **Best Practices for Avoiding and Handling Drift**

- **Treat Terraform Configuration as the Single Source of Truth**: Avoid making changes outside Terraform to resources it manages. This helps prevent unexpected drift.
- **Implement Version Control for Configurations**: Use Git or another version control system to track changes, so any configuration updates can be reviewed, and unwanted drift can be reverted if necessary.
- **Use Infrastructure as Code (IaC) Principles**: Plan and execute all infrastructure changes as code to keep the configuration, state file, and actual infrastructure synchronized.
- **Automate `terraform plan`**: In production environments, consider automating `terraform plan` (e.g., as part of a CI/CD pipeline) to regularly check for drift and alert you to any unexpected changes.

---

## 8. **Key Takeaways**

- **Drift** represents inconsistencies between Terraform’s state file and the actual infrastructure.
- **`terraform plan`** is your primary tool for detecting drift.
- **`terraform apply`** can resolve drift by reconciling the actual infrastructure with the Terraform configuration.
- Beginners often find drift confusing due to the new concepts around the state file, the “single source of truth” approach, and unfamiliar terminology.

Understanding and managing drift is essential for infrastructure reliability. By following best practices and understanding Terraform’s drift management tools, you can ensure that your infrastructure remains consistent, predictable, and easy to manage.