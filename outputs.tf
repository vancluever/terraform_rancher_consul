// module terraform_rancher_consul_user_data

// The rendered user data.
output "user_data_rendered" {
  value = "${module.consul_rancher_user_data.rendered}"
}
