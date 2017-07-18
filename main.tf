/**
 * # terraform_rancher_consul
 * 
 * Module `terraform_rancher_consul` provides a semantic way to generate
 * `cloud-config` entries that can configure [RancherOS][1] to launch instances
 * with the [official Consul Docker image][2] loaded as a service.  This module
 * mainly serves as an example of how you can use
 * [`terraform_rancher_service`][3] and [`terraform_rancher_user_data`][4] to
 * create pre-created user data for Rancher, but the example will work very
 * well for a Consul server cluster.
 * 
 * [1]: http://rancher.com/rancher-os/
 * [2]: https://hub.docker.com/_/consul/
 * [3]: https://github.com/vancluever/terraform_rancher_service
 * [4]: https://github.com/vancluever/terraform_rancher_user_data
 * 
 * Usage Example:
 * 
 *     module "consul_server_agent" {
 *       source                   = "github.com/vancluever/terraform_rancher_consul?ref=VERSION"
 *       consul_version           = "0.8.5"
 *       retry_join_ec2_tag_key   = "consulrole_server"
 *       retry_join_ec2_tag_value = "true"
 *       server_mode              = "false"
 *     }
 *     
 *     output "consul_server_agent_user_data" {
 *       value = "${module.consul_server_agent.user_data_rendered}"
 *     }
 * 
 */

