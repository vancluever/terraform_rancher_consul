// Copyright 2017 Chris Marchesi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// vpc creates the VPC that will get created for our project.
module "vpc" {
  source                  = "github.com/paybyphone/terraform_aws_vpc?ref=v0.1.0"
  project_path            = "${var.project_path}"
  public_subnet_addresses = ["${var.public_subnet_addresses}"]
  vpc_network_address     = "${var.vpc_network_address}"
}

// consul_alb creates the ALB that supervises the consul instances.
//
// Note that in addition to supervising the consul instances and providing
// auto-healing, this also serves up the UI and API. As a result, it's
// recommended that you restrict traffic on this ALB.
module "consul_alb" {
  source               = "github.com/paybyphone/terraform_aws_alb?ref=v0.1.0"
  listener_subnet_ids  = ["${module.vpc.public_subnet_ids}"]
  project_path         = "${var.project_path}"
  restrict_to_networks = ["${var.ssh_inbound_ip_address}"]
}

// consul_server_user_data creates the full cloud-config for the consul server
// cluster to load into the consul server ASG.
module "consul_server_user_data" {
  source                   = "../../"
  consul_version           = "0.8.5"
  retry_join_ec2_tag_key   = "consulrole_server"
  retry_join_ec2_tag_value = "true"
  server_mode              = "true"
  enable_ui                = "true"
}

// consul_autoscaling_group creates the autoscaling group that will get created
// for our project.
//
// The ALB is also attached to this autoscaling group with the default /* path
// pattern.
module "consul_autoscaling_group" {
  source                      = "github.com/paybyphone/terraform_aws_asg?ref=v0.2.4"
  alb_health_check_uri        = "/v1/agent/self"
  alb_listener_arn            = "${module.consul_alb.alb_listener_arn}"
  alb_service_port            = "8500"
  associate_public_ip_address = "true"
  enable_alb                  = "true"
  image_filter_type           = "name"
  image_filter_value          = "rancheros-v*-hvm-1"
  image_owner                 = "605812595337"
  instance_profile_name       = "${aws_iam_instance_profile.consul_instance_profile.name}"
  key_pair_name               = "${var.key_pair_name}"
  max_instance_count          = "3"
  min_instance_count          = "3"
  project_path                = "${var.project_path}"
  subnet_ids                  = ["${module.vpc.public_subnet_ids}"]
  user_data                   = "${module.consul_server_user_data.user_data_rendered}"

  extra_instance_tags = [
    {
      key                 = "consulrole_server"
      value               = "true"
      propagate_at_launch = "true"
    },
  ]
}

// consul_security_group_rule_rpc adds intra-security group access to Consul
// RPC for the ASG's security group.
resource "aws_security_group_rule" "consul_security_group_rule_rpc" {
  from_port                = 8300
  protocol                 = "tcp"
  security_group_id        = "${module.consul_autoscaling_group.instance_security_group_id}"
  source_security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port                  = 8300
  type                     = "ingress"
}

// consul_security_group_rule_serf_lan_tcp adds intra-security group access to
// Consul Serf (LAN TCP) for the ASG's security group.
resource "aws_security_group_rule" "consul_security_group_rule_serf_lan_tcp" {
  from_port                = 8301
  protocol                 = "tcp"
  security_group_id        = "${module.consul_autoscaling_group.instance_security_group_id}"
  source_security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port                  = 8301
  type                     = "ingress"
}

// consul_security_group_rule_serf_lan_udp adds intra-security group access to
// Consul Serf (LAN UDP) for the ASG's security group.
resource "aws_security_group_rule" "consul_security_group_rule_serf_lan_udp" {
  from_port                = 8301
  protocol                 = "udp"
  security_group_id        = "${module.consul_autoscaling_group.instance_security_group_id}"
  source_security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port                  = 8301
  type                     = "ingress"
}

// consul_security_group_rule_serf_wan_tcp adds intra-security group access to
// Consul Serf (WAN TCP) for the ASG's security group.
resource "aws_security_group_rule" "consul_security_group_rule_serf_wan_tcp" {
  from_port                = 8302
  protocol                 = "tcp"
  security_group_id        = "${module.consul_autoscaling_group.instance_security_group_id}"
  source_security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port                  = 8302
  type                     = "ingress"
}

// consul_security_group_rule_serf_wan_udp adds intra-security group access to
// Consul Serf (WAN UDP) for the ASG's security group.
resource "aws_security_group_rule" "consul_security_group_rule_serf_wan_udp" {
  from_port                = 8302
  protocol                 = "udp"
  security_group_id        = "${module.consul_autoscaling_group.instance_security_group_id}"
  source_security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port                  = 8302
  type                     = "ingress"
}

// ssh_security_group_rule allows SSH into the instances from
// a specific IP address.
resource "aws_security_group_rule" "ssh_security_group_rule" {
  count             = "${var.ssh_inbound_ip_address != "" ? 1 : 0 }"
  cidr_blocks       = ["${var.ssh_inbound_ip_address}"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${module.consul_autoscaling_group.instance_security_group_id}"
  to_port           = 22
  type              = "ingress"
}
