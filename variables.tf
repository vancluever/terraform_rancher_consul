// module terraform_rancher_consul_user_data

// The Consul version to install.
variable "consul_version" {
  type = "string"
}

// The datacenter to configure this node for. Notes in the same datacenter must
// be on a single LAN.
variable "consul_datacenter" {
  type    = "string"
  default = "dc1"
}

// Enable server mode. This sets the -server option if it is `true`.
variable "server_mode" {
  type    = "string"
  default = "false"
}

// (Server mode only) the number of servers we want available before
// bootstrapping a new cluster.
variable "bootstrap_expect" {
  type    = "string"
  default = "3"
}

// The EC2 tag key to use for server discovery.
//
// Note that not specifying this in a non-agent mode configuration will more
// than likely mean that the module will not be able to join any nodes.
variable "retry_join_ec2_tag_key" {
  type    = "string"
  default = ""
}

// The EC2 tag value to use for server discovery.
//
// This needs to be specified with retry_join_ec2_tag_key.
variable "retry_join_ec2_tag_value" {
  type    = "string"
  default = ""
}

// The log level that should be used. Needs to be one of "TRACE", "DEBUG",
// "INFO", "WARN", and "ERR".
variable "log_level" {
  type    = "string"
  default = "INFO"
}

// Enable the built-in server UI.
variable "enable_ui" {
  type    = "string"
  default = "false"
}
