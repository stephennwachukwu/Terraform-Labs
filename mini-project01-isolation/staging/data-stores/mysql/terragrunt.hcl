include "root" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../../global/network"
}




inputs = {
  db_private_subnet_id = dependency.network.outputs.data_layer_subnet_id
  vpc_id = dependency.network.outputs.vpc_id
}

terraform {
  extra_arguments "sensitive_vars" {
    commands = get_terraform_commands_that_need_vars()

    env_vars = {
      TF_VAR_db_username  = get_env("TF_VAR_DB_USERNAME")
      TF_VAR_db_password = get_env("TF_VAR_DB_PASSWORD")
    }
  }
}
