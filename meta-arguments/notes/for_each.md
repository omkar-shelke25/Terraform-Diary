# for_each 

## Why Use `for_each`?

`for_each` is a powerful feature in Terraform because it allows you to create multiple instances of a resource or module based on the values in a list or map. Imagine you need to create similar resources (like multiple storage buckets or servers) but with slight differences — `for_each` allows you to do this with ease.

---

## Basic Concepts of `for_each`

1. **Using a Set of Strings with `for_each`**
    - When you use a **set of strings** (like a list of names) with `for_each`, each string is treated as both the key and the value.
    - **Example**: Say you want to create a storage bucket for each team member: Jack and James.
        
        ```hcl
        resource "aws_s3_bucket" "example" {
          for_each = toset(["Jack", "James"])
        
          bucket = "${each.key}-bucket"
        }
        
        ```
        
    - **Explanation**:
        - `for_each = toset(["Jack", "James"])`: Tells Terraform to create one S3 bucket for each person in the set.
        - `each.key` and `each.value` both represent the person's name ("Jack" and "James") because it's a set.
        - Terraform will create two S3 buckets: `Jack-bucket` and `James-bucket`.
2. **Using a Map with `for_each`**
    - With a **map**, you can separate keys and values, making it ideal for more complex configurations where you need pairs (e.g., environment and bucket name).
    - **Example**: Create buckets based on different environments (like `dev` and `prod`).
        
        ```hcl
        resource "aws_s3_bucket" "example" {
          for_each = {
            dev  = "dev-bucket"
            prod = "prod-bucket"
          }
        
          bucket = each.value
          tags = {
            Environment = each.key
          }
        }
        
        ```
        
    - **Explanation**:
        - `for_each` has a map with `dev` and `prod` as keys and the bucket names as values.
        - `each.key` gives the environment (e.g., `dev`), and `each.value` gives the bucket name (e.g., `dev-bucket`).
        - Terraform creates two buckets and tags them based on their environment.

---

## How `for_each` Works with Modules

Before Terraform 0.13, `for_each` could only be used with resources. Starting from version 0.13, you can use `for_each` with modules, making it possible to create multiple instances of a module with different configurations.

**Example**: Imagine you have a module for setting up VPCs, and you want to deploy a VPC in multiple regions.

```hcl
module "vpc" {
  source = "./vpc-module"

  for_each = {
    us-east-1 = "10.0.0.0/16"
    eu-west-1 = "10.1.0.0/16"
  }

  region      = each.key
  cidr_block  = each.value
}

```

- **Explanation**:
    - Each region is specified as a key (like `us-east-1`), and each VPC’s CIDR block as the value.
    - Terraform will create one VPC in `us-east-1` and another in `eu-west-1` with the specified CIDR blocks.

---

## Key Points to Remember

1. **Additional `each` Object**:
    - In `for_each` blocks, Terraform provides an `each` object.
    - `each.key` and `each.value` give you access to the key and value for each instance being created.
2. **Differences Between Set and Map**:
    - When `for_each` is a set, `each.key` is the same as `each.value`.
    - When `for_each` is a map, `each.key` and `each.value` represent the map’s key-value pairs, allowing for more configuration flexibility.
3. **Production Use**:
    - `for_each` is very useful in production, as it minimizes repetitive code and makes it easy to manage multiple instances of similar resources.
    - It enables modular and scalable Terraform configurations, which is essential for production environments where infrastructure components often need to be deployed across multiple regions or environments.
4. **Certification Significance**:
    - In Terraform certification, understanding `for_each` demonstrates your ability to use Terraform efficiently.
    - Being aware that `for_each` support in modules began with Terraform 0.13 can be helpful, as certification exams often test knowledge of specific features by version.

5.**Remember:**
    - `for_each` with a set of strings lets `each.key` and `each.value` be the same.
    - With a **map**, you can use `each.key` and `each.value` for more complex resource configurations.
    - **Count vs. `for_each`**: You must pick either `count` or `for_each` for a single resource or module block; they cannot be combined.

---

## Real-World Use Cases

1. **Deploying in Multiple Environments**:
    - Use `for_each` with a map to create resources like S3 buckets or VPCs across environments (e.g., `dev`, `test`, `prod`).
2. **Creating Similar Resources with Minor Differences**:
    - You might use `for_each` to create multiple EC2 instances with slightly different configurations, such as tags or instance sizes.

By using `for_each` efficiently, you can create flexible, scalable Terraform configurations that are easier to manage and update. Let me know if you have more specific questions or need further examples!

# Summary

- Use `for_each` to create multiple instances of resources based on a set or map.
- With a **set of strings**, `each.key` and `each.value` are the same.
- With a **map**, you can use `each.key` and `each.value` for more complex resource configurations.
- Remember, **you cannot combine** `count` and `for_each` in the same block.