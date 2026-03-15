terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "zac_zac_fedora" {
  name = "zac@zac (Fedora)"
}

data "digitalocean_ssh_key" "zac_zacbook" {
  name = "zac@zacbook"
}


# https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet#ipv4_address-1
output "k8s_node_01_ip" {
  value = digitalocean_droplet.k8s-node-01.ipv4_address
}
output "k8s_node_02_ip" {
  value = digitalocean_droplet.k8s-node-02.ipv4_address
}
output "k8s_node_03_ip" {
  value = digitalocean_droplet.k8s-node-03.ipv4_address
}
