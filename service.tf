// module terraform_rancher_consul_user_data

// client_mode_tempalte templates command line options for client mode.
data "template_file" "client_mode_template" {
  template = <<EOS
-datacenter ${var.consul_datacenter}
${var.retry_join_ec2_tag_key != "" ? format("-retry-join-ec2-tag-key %s", var.retry_join_ec2_tag_key) : "" }
${var.retry_join_ec2_tag_key != "" ? format("-retry-join-ec2-tag-value %s", var.retry_join_ec2_tag_value) : "" }
-log-level ${var.log_level}
EOS
}

// server_mode_tempalte templates command line options for client mode.
data "template_file" "server_mode_template" {
  template = <<EOS
-server -datacenter ${var.consul_datacenter}
-bootstrap-expect ${var.bootstrap_expect}
${var.retry_join_ec2_tag_key != "" ? format("-retry-join-ec2-tag-key %s", var.retry_join_ec2_tag_key) : "" }
${var.retry_join_ec2_tag_key != "" ? format("-retry-join-ec2-tag-value %s", var.retry_join_ec2_tag_value) : "" }
-log-level ${var.log_level}
${var.enable_ui == "true" ? "-ui" : "" }
EOS
}

// consul_rancher_service provides the service snippets for our containerized
// Consul service.
module "consul_rancher_service" {
  source       = "github.com/vancluever/terraform_rancher_service"
  service_name = "consul"
  image_name   = "consul:${var.consul_version}"
  network_mode = "host"
  command      = "agent ${var.server_mode == "true" ? replace(data.template_file.server_mode_template.rendered, "\n", " ") : replace(data.template_file.client_mode_template.rendered, "\n", " ")}"

  environment = {
    "CONSUL_BIND_INTERFACE"   = "eth0"
    "CONSUL_CLIENT_INTERFACE" = "eth0"
  }
}

// consul_rancher_user_data provides our rendered user data.
module "consul_rancher_user_data" {
  source                  = "github.com/vancluever/terraform_rancher_user_data"
  rancher_service_entries = ["${module.consul_rancher_service.rancher_service_data}"]
}
