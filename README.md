# terraform_rancher_consul

Module `terraform_rancher_consul` provides a semantic way to generate
`cloud-config` entries that can configure [RancherOS][1] to launch instances
with the [official Consul Docker image][2] loaded as a service.  This module
mainly serves as an example of how you can use
[`terraform_rancher_service`][3] and [`terraform_rancher_user_data`][4] to
create pre-created user data for Rancher, but the example will work very
well for a Consul server cluster.

[1]: http://rancher.com/rancher-os/
[2]: https://hub.docker.com/_/consul/
[3]: https://github.com/vancluever/terraform_rancher_service
[4]: https://github.com/vancluever/terraform_rancher_user_data

Usage Example:

    module "consul_server_agent" {
      source                   = "github.com/vancluever/terraform_rancher_consul?ref=VERSION"
      consul_version           = "0.8.5"
      retry_join_ec2_tag_key   = "consulrole_server"
      retry_join_ec2_tag_value = "true"
      server_mode              = "false"
    }

    output "consul_server_agent_user_data" {
      value = "${module.consul_server_agent.user_data_rendered}"
    }



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bootstrap_expect | (Server mode only) the number of servers we want available before bootstrapping a new cluster. | string | `3` | no |
| consul_datacenter | The datacenter to configure this node for. Notes in the same datacenter must be on a single LAN. | string | `dc1` | no |
| consul_version | The Consul version to install. | string | - | yes |
| enable_ui | Enable the built-in server UI. | string | `false` | no |
| log_level | The log level that should be used. Needs to be one of "TRACE", "DEBUG", "INFO", "WARN", and "ERR". | string | `INFO` | no |
| retry_join_ec2_tag_key | The EC2 tag key to use for server discovery.<br><br>Note that not specifying this in a non-agent mode configuration will more than likely mean that the module will not be able to join any nodes. | string | `` | no |
| retry_join_ec2_tag_value | The EC2 tag value to use for server discovery.<br><br>This needs to be specified with retry_join_ec2_tag_key. | string | `` | no |
| server_mode | Enable server mode. This sets the -server option if it is `true`. | string | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| user_data_rendered | The rendered user data. |

