# This file is used for providing values to the variables declared in your variables.tf file

# By default only the "terraform.tfvar" file is applied..
# If we want some other file to be applied, then we need to explicityly set it up via command line arguments.
# Ex.: $ terraform apply -var-file="LOCATION_OF_THE_FILE"

bucket_prefix = "devops-directive-web-app-data"
domain        = "devopsdeployed.com"
db_name       = "mydb"
db_user       = "foo"
# db_pass = "foobarbaz"
