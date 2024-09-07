# AWS EC2

## What is EC2?

- EC2, or Elastic Compute Cloud, is a service provided by Amazon Web Services (AWS) that allows users to rent virtual computers on which to run their own computer applications.
- It mainly consists in the capability of :
    - Renting virtual machines (EC2)
    - Storing data on virtual drives (EBS)
    - Distributing load across machines (ELB)
    - Scaling the services using an auto-scaling group (ASG)
    
    ```
    EC2 Instance Components Flowchart
    
    1. EC2 Instance
       ├── OS (Operating System: Linux, Windows, or Mac OS)
       ├── CPU (Compute power & cores)
       └── RAM (Random-access memory)
    2. Storage
       ├── EBS (Elastic Block Store)
       ├── EFS (Elastic File System)
       └── EC2 Instance Store (hardware)
    3. Network
       ├── VPC (Virtual Private Cloud)
       ├── Security Groups (Firewall rules)
       ├── Network ACLs
       ├── Elastic IPs (Public IP address)
       └── Network card (speed of the card)
    4. Configuration
       └── Bootstrap Script (EC2 User Data, configure at first launch)
    5. Auto Scaling Group (ASG)
       └── Scaling Policies
    6. Permissions
       └── IAM Roles
    7. Monitoring
       └── CloudWatch
    ```
    

## Benefits

- **Scalability**: With EC2, you can increase or decrease capacity within minutes, not hours or days.
- **Cost-Effective**: You pay only for the capacity that you actually use.
- **Integrated** – EC2 is integrated with most AWS services such as S3, RDS, and VPC to provide a complete, secure solution.
- **Secure**: EC2 works in conjunction with Amazon VPC to provide security and robust networking functionality for your compute resources.

## Key Features

- **Elastic Block Store (EBS)**: It provides persistent block storage volumes for use with Amazon EC2 instances.
- **Elastic Load Balancing (ELB)**: It automatically distributes incoming application traffic across multiple targets, such as EC2 instances.
- **Auto Scaling**: It ensures that you have the correct number of Amazon EC2 instances available to handle the load for your application.

## Instance Types

EC2 provides a variety of instance types optimized to fit different use cases. Instance types comprise varying combinations of CPU, memory, storage, and networking capacity.

Remember to choose the right instance type based on your specific needs!

## Instance Types Overview

Instance types in EC2 are categorized into five broad families, each designed for different types of workloads:

- **General Purpose**: These instances provide a balance of compute, memory, and networking resources, and can be used for a variety of diverse workloads.
- **Compute Optimized**: These instances are ideal for compute-bound applications that benefit from high-performance processors. Give imortance of proceessors
- **Memory Optimized**: These instances are designed to deliver fast performance for workloads that process large data sets in memory.Give the imoirtance of ram
- **Storage Optimized**: These instances are designed for workloads that require high, sequential read and write access to very large data sets on local storage.
- **Accelerated Computing**: These instances use hardware accelerators, or co-processors, to perform functions, such as floating-point number calculations, graphics processing, or data pattern matching, more efficiently than is possible in software running on CPUs.

Each instance type provides a different mix of these resources, allowing you to choose the appropriate trade-off of resources for your applications.