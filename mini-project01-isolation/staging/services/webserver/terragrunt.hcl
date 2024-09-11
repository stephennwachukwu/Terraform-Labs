include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../../global/network/"
}

dependency "data-stores" {
  config_path = "../../data-stores/mysql/"
}

inputs = {
  subnet_id            = dependency.network.outputs.public_subnet_id
  http_ssh_sg_id       = [dependency.network.outputs.ssh_http_security_group_id]
  elb_sg_id            = [dependency.network.outputs.elb_security_group_id]
  elb_subnet_ids        = dependency.network.outputs.elb_subnet_id
  key_name             = "deployer-key"

  db_host              = dependency.data-stores.outputs.db_instance_endpoint
  db_name              = dependency.data-stores.outputs.db_instance_name
  vpc_id               = dependency.network.outputs.vpc_id
}

terraform {
  extra_arguments "sensitive_vars" {
    commands = get_terraform_commands_that_need_vars()

    env_vars = {
      TF_VAR_user_password  = get_env("TF_VAR_USER_PASSWORD")
      TF_VAR_ssh_public_key = get_env("TF_VAR_SSH_PUBLIC_KEY")
      TF_VAR_db_username  = get_env("TF_VAR_DB_USERNAME")
      TF_VAR_db_password = get_env("TF_VAR_DB_PASSWORD")
    }
  }
}
