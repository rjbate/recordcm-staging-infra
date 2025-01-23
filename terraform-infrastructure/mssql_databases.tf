resource "azurerm_mssql_database" "staging" {
  name            = "sqldb-${var.azure_devops_project_target}-${var.record_env}-staging-00"
  server_id       = data.terraform_remote_state.shared_state.outputs.maindb_server_id
  elastic_pool_id = data.terraform_remote_state.shared_state.outputs.sql_ep_id

  max_size_gb = 32

  tags = merge(local.env_tag, var.common_tags)
}
