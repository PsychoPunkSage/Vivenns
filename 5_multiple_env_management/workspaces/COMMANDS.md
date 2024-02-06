## Command-Line Interface

> **`terraform init`**
- initialization of terraform project

> **`terraform workspace list`**
- if workspace list exists, it will show the list. ELSE it will show `*default`

> **`terraform workspace new production`**
- creates a new enviroment named `production` and makes it active

> **`terraform apply`**
- this command will make necessary changes via `Provider`<br>
- make sure that `Desired State == Actual State`

> **`terraform destroy`**
- destroys everything
- make sure to destroy everything from every environment.
- use `terraform workspace select "env_name"` and then do `terraform destroy`