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

// The key pair to launch the instances with.
variable "key_pair_name" {
  type = "string"
}

// The IP address to allow SSH inbound from.
variable "ssh_inbound_ip_address" {
  type = "string"
}

// The project path.
variable "project_path" {
  type    = "string"
  default = "vancluever/terraform_rancher_consul"
}

// The IP space for the VPC.
variable "vpc_network_address" {
  type    = "string"
  default = "10.0.0.0/24"
}

// The IP space for the public subnets within the VPC.
variable "public_subnet_addresses" {
  type    = "list"
  default = ["10.0.0.0/25", "10.0.0.128/25"]
}
