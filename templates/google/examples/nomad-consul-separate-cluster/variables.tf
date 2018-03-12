# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "gcp_project" {
  description = "The name of the GCP Project where all resources will be launched."
  default = "legal-entity"
}

variable "gcp_region" {
  description = "Europe West 2 - London"
  default = "europe-west2"
}

variable "gcp_zone" {
  description = "Europe West 2a"
  default = "europe-west2-a"
}

# Nomad Server cluster

variable "nomad_server_cluster_name" {
  description = "The name of the Nomad Server cluster. All resources will be namespaced by this value. E.g. nomad-server-prod"
  default = "nomad-server-cluster-test"
}

variable "nomad_server_source_image" {
  description = "The Google Image used to launch each node in the Nomad/Consul Server cluster."
  default = "nomad-consul-2017-11-27-011818"
}

# Nomad Client cluster

variable "nomad_client_cluster_name" {
  description = "The name of the Nomad client cluster. All resources will be namespaced by this value. E.g. consul-server-prod"
  default = "nomad-client-cluster-test"
}

variable "nomad_client_source_image" {
  description = "The Google Image used to launch each node in the Nomad client cluster."
  default = "nomad-consul-2017-11-27-011818"
}

# Consul Server cluster

variable "consul_server_cluster_name" {
  description = "The name of the Consul Server cluster. All resources will be namespaced by this value. E.g. consul-server-prod"
  default = "consul-server-cluster-test"
}

variable "consul_server_source_image" {
  description = "The Google Image used to launch each node in the Consul Server cluster."
  default = "nomad-consul-2017-11-27-011818"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

# Nomad Server cluster

variable "nomad_server_cluster_size" {
  description = "The number of nodes to have in the Nomad Server cluster. We strongly recommended that you use either 3 or 5."
  default = 3
}

variable "nomad_server_cluster_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Vault cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

# Nomad Client cluster

variable "nomad_client_cluster_size" {
  description = "The number of nodes to have in the Nomad client cluster. This number is arbitrary."
  default = 2
}

variable "nomad_client_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Nomad client cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

# Consul Server cluster

variable "consul_server_cluster_size" {
  description = "The number of nodes to have in the Consul Server cluster. We strongly recommended that you use either 3 or 5."
  default = 3
}

variable "consul_server_machine_type" {
  description = "The machine type of the Compute Instance to run for each node in the Consul Server cluster (e.g. n1-standard-1)."
  default = "g1-small"
}

variable "allowed_inbound_cidr_blocks_http" {
  description = "The cidr block to allow comms between within your clusters"
}

variable "allowed_inbound_cidr_blocks_rpc" {
  description = "The cidr block to allow comms between within your clusters"
}

variable "allowed_inbound_cidr_blocks_serf" {
  description = "The cidr block to allow comms between within your clusters"
}

variable "network_name" {
  description = "Leto dev network"
}

variable "subnetwork_link" {
  description = "Let dev subnetwork"
}

