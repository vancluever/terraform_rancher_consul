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

// The endpoint for the UI and HTTP API. This should be sufficiently protected.
output "alb_hostname" {
  value = "${module.consul_alb.alb_dns_name}"
}

// The security group ID for the created load balancer.
output "alb_security_group_id" {
  value = "${module.consul_alb.alb_security_group_id}"
}

// The security group ID for the created auto-scaling group.
output "asg_instance_security_group_id" {
  value = "${module.consul_autoscaling_group.instance_security_group_id}"
}
