
# Kubernetes ARC Runner Setup

This is a basic setup to create GitHub Actions Runner Controller (ARC) support for a repository.

The flow is as follows:

1. Use Terraform to provision DigitalOcean droplet VMs to run a Kubernetes cluster.
2. Use Ansible to install [RKE2](https://docs.rke2.io/) as the Kubernetes cluster.
3. Use Helm to install the ARC controller and runner sets on the cluster.

Actions run on the target repository can request to be run on the self-hosted runners,
which will appear as ephemeral pods in the Kubernetes cluster.

See https://github.com/zaccrites/github-runner-test-repo for example usage of this setup.


## Create the Cluster

1. Create a DigitalOcean [personal access token](https://cloud.digitalocean.com/account/api/tokens)
   with the `droplet` scope.
2. Add your SSH key to your DigitalOcean profile to use to login to the droplets later.
2. Create the file `terraform/credentials` and add your DigitalOcean token, following the example.
3. Replace references to SSH keys in the terraform config to your own uploaded SSH key name.
3. Run `setup.sh` to create the DigitalOcean droplets and provision the Kubernetes cluster.

## Install ARC

1. Create a new "classic" GitHub [personal access token](https://github.com/settings/tokens)
   with the `repo` scope.
2. Create the file `github_arc/credentials` in the repository, following the example.
   Add your token and replace the example GitHub repository URL with your own repository URL.
3. Run `github_arc/install.sh` to install ARC onto the cluster.


## Tear Down the Cluster

DigitalOcean incurs a fee for the droplets whether they take jobs or not,
so you may wish to destroy them when not in use.
Run `terraform/run.sh destroy` to destroy the VMs.
