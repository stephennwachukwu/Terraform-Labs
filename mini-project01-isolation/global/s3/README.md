# S3 Remote State Example using Terragrunt

This folder contains example [Terragrunt](https://terragrunt.gruntwork.io/) configuration that creates an 
[S3](https://aws.amazon.com/s3/) bucket and [DynamoDB](https://aws.amazon.com/dynamodb/) table in an 
[Amazon Web Services (AWS) account](http://aws.amazon.com/). The S3 bucket and DynamoDB table can be used as a 
[remote backend for Terraform](https://www.terraform.io/docs/backends/).

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

Specify a name for the S3 bucket and DynamoDB table in `terragrunt.hcl` using the `inputs` block:

```hcl
inputs = {
  bucket_name = "<YOUR BUCKET NAME>"
  table_name  = "<YOUR TABLE NAME>"
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

1. Terragrunt uses a `terragrunt.hcl` file instead of `terraform.tfvars`.
2. You can define common configurations (like backend configuration) in a root `terragrunt.hcl` file and inherit them in child directories.
3. Terragrunt can manage remote state for you, simplifying the backend configuration.
4. With Terragrunt, you can easily work with multiple environments (dev, staging, prod) by using different configuration files.

For more detailed information on using Terragrunt, please refer to the [official Terragrunt documentation](https://terragrunt.gruntwork.io/docs/).