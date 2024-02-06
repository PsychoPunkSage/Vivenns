## Command-Line Interface

> **`terraform init`** (global >> main.tf )
- initialization of global terraform project. 
- first we need to initialize terraform project that is common to both "staging" and "production".

> **`terraform apply`** (global >> main.tf )
- this will create common resources for our further build.

> **`terraform init`** (production >> main.tf )
- initialization of production terraform project.

> **`terraform apply`** (production >> main.tf )
- this will create production env resources for our further build.