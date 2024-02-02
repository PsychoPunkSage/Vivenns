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

## Thank You 😇