include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../../global/network/"
}

inputs = {
  subnet_id = dependency.network.outputs.public_subnet_id
  vpc_security_group_ids = [dependency.network.outputs.ssh_http_security_group_id]
  key_name               = "deployer-key"
}

terraform {
  extra_arguments "sensitive_vars" {
    commands = get_terraform_commands_that_need_vars()

    env_vars = {
      TF_VAR_user_password  = get_env("TF_VAR_USER_PASSWORD")
      TF_VAR_ssh_public_key = get_env("TF_VAR_SSH_PUBLIC_KEY")
    }
  }
}
