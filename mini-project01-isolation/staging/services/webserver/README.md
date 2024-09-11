# Web Server Cluster Example using Terragrunt

This folder contains an example [Terragrunt](https://terragrunt.gruntwork.io/) configuration that deploys a cluster of web servers 
(using [EC2](https://aws.amazon.com/ec2/) and [Auto Scaling](https://aws.amazon.com/autoscaling/)) and a load balancer
(using [ELB](https://aws.amazon.com/elasticloadbalancing/)) in an [Amazon Web Services (AWS) 
account](http://aws.amazon.com/). The load balancer listens on port 80 and returns the text "Hello, World" for the 
`/` URL.

For more info, please see Chapter 3, "How to Manage Terraform State", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) installed on your computer.
* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* You must deploy the MySQL database in [data-stores/mysql](../../data-stores/mysql) BEFORE deploying the
  configuration in this folder.

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
Generate the ssh-key locally and configure the webserver credentials as environment variables:

```
export TF_VAR_ssh_public_key=(desired database username)
export TF_VAR_user_password=(desired database password)
```

Create a `terragrunt.hcl` file in your project root directory and configure the remote state backend and input variables. Here's an example:

```hcl
remote_state {
  backend = "s3"
  config = {
    bucket = "<YOUR BUCKET NAME>"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-2"
  }
}

inputs = {
  db_remote_state_bucket = "<YOUR BUCKET NAME>"
  db_remote_state_key    = "<YOUR STATE PATH>"
}
```

Deploy the code:

```
terragrunt init
terragrunt apply
```

When the `apply` command completes, it will output the DNS name of the load balancer. To test the load balancer:

```
curl http://<alb_dns_name>/
```

Clean up when you're done:

```
terragrunt destroy
```

## Notes on using Terragrunt

Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules. Here are a few key points:

1. Terragrunt uses a `terragrunt.hcl` file for configuration instead of directly editing Terraform files.
2. Remote state configuration is handled in the `terragrunt.hcl` file, simplifying backend setup.
3. You can use Terragrunt's built-in functions and features to make your configurations more DRY and maintainable.
4. Terragrunt makes it easier to work with multiple environments by allowing you to inherit configurations.

For more detailed information on using Terragrunt, please refer to the [official Terragrunt documentation](https://terragrunt.gruntwork.io/docs/).