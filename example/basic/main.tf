// consul_server_agent gives agent user data for a server.
module "consul_server_agent" {
  source                   = "../"
  consul_version           = "0.7.2"
  retry_join_ec2_tag_key   = "consulrole_server"
  retry_join_ec2_tag_value = "true"
  server_mode              = "false"
}

// consul_client_agent gives agent user data for a client.
module "consul_client_agent" {
  source                   = "../"
  consul_version           = "0.7.2"
  retry_join_ec2_tag_key   = "consulrole_server"
  retry_join_ec2_tag_value = "true"
  server_mode              = "false"
}

// The user data for the Consul server.
//
// Note that the leading newline is for display purposes only.
output "consul_server_agent_user_data" {
  value = "\n${module.consul_server_agent.user_data_rendered}"
}

// The user data for the Consul client.
//
// Note that the leading newline is for display purposes only.
output "consul_client_agent_user_data" {
  value = "\n${module.consul_client_agent.user_data_rendered}"
}
