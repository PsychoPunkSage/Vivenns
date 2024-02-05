# Hi 👋

The folders are named as per sequence. Please follow the sequence to get maximum out of it.

## Common Terminologies

> `State File`

1. Terraform representation of the world.
2. **JSON file** containing info about every resources and data object that we have deployed using terraform.
3. Contains sensitive information (like password of database etc.), so needs to be properly protected and encrypted.
4. Can be stored locally or remotely.

`Local Backend`
- Simple
- Sensitive values in plain text
- Uncollaborative
- Manual

`Remote Backend`
- Sensitive data encrypted
- Collaboration possible
- Automation possible
- Increased complexity 

> `$ Terraform plan`

Compares **Desired** Terraform config files (that we have created) with the Actual State.<br>
Incase of difference, it will `plan` a series of API/commands needed to make necessary changes.

> `$ Terraform apply`

This command will make necessary changes via `Provider`<br>
Make sure that `Desired State == Actual State`

> `$ Terraform destroy`

Destroy everything

## **Concepts**

> **Meta-Arguments**

`depends_on`
- Terraform auto generates dependency graph based on references.
- If two resources depend on one another, **depends_on** specifies that dependency to enforce ordering.
- Example: if a software on the instance needs access to S3, trying to create the **aws_instance** would fail if the attempting to create it before the `aws_iam_role_policy`.
- So, it helps us to give hints to terraform about proper ordering to follow to avoid any issues.

`count`
- Allows for the creation of the multiple resources.modules from a single block.
- Useful when the multiple necessary resources are nearly identical.

`for_each`
- Allows for the creation of the multiple resources.modules from a single block.
- Allows more control to customize each resources than a count.
- Here we initiate some kind of **iteration** to coustomize resources.

`lifecycle`
- It is a set of meta arguments to control terraform behaviour for specific resources.
- **create_before_destroy** can help with **0 downtime** deployments. It specifies that a new resource should be created before current one is destroyed.
- **ignore_changes** prevents Terraform from trying to revert metadata being set elsewhere. (Some resources have metadata modified automatically outside of the terraform)
- **prevent_destroy** causes Terraform to reject any plan which would destroy this resources.

## Thank You 😇