#!/bin/bash
# This script is meant to be run in the Startup Script of each Compute Instance while it's booting. The script uses the
# run-consul script to configure and start Consul in server mode. Note that this script assumes it's running in a Compute
# Instance built from the Packer template in examples/consul.json in the Consul GCP Module.

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# Inspired by https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --server --cluster-tag-name "${consul_server_cluster_tag_name}"