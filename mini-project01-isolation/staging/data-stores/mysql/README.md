# MySQL on RDS Example using Terragrunt

This folder contains an example [Terragrunt](https://terragrunt.gruntwork.io/) configuration that deploys a MySQL database (using 
[RDS](https://aws.amazon.com/rds/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 

For more info, please see Chapter 3, "How to Manage Terraform State", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) installed on your computer. 
* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

Please note that this code was written for Terragrunt compatible with Terraform 1.x.

## Quick start

**Please note that this example will deploy real resources into your AWS account. We have made every effort to ensure 
all the resources qualify for the [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any
charges you may incur.** 

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Configure the database credentials as environment variables:

```
export TF_VAR_db_username=(desired database username)
export TF_VAR_db_password=(desired database password)
```

Create a `terragrunt.hcl` file in your project root directory and configure the remote state backend. Here's an example:

```hcl
remote_state {
  backend = "s3"
  config = {
    bucket         = "your-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "your-lock-table"
  }
}

inputs = {
  db_username = "${get_env("TF_VAR_db_username")}"
  db_password = "${get_env("TF_VAR_db_password")}"
}
```

Deploy the code:

```
terragrunt init
terragrunt apply
```

Clean up when you're done:

```
terragrunt destroy
```

## Notes on using Terragrunt

Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules. Here are a few key points:

1. Terragrunt uses a `terragrunt.hcl` file for configuration instead of directly editing Terraform files.
2. Remote state configuration is handled in the `terragrunt.hcl` file, simplifying backend setup.
3. You can use Terragrunt's built-in functions like `get_env()` to read environment variables.
4. Terragrunt makes it easier to work with multiple environments by allowing you to inherit configurations.

For more detailed information on using Terragrunt, please refer to the [official Terragrunt documentation](https://terragrunt.gruntwork.io/docs/).