# https://slugs.do-api.dev/
# http://www.terraform.io/docs/providers/do/r/droplet

resource "digitalocean_droplet" "k8s-node-01" {
  image = "ubuntu-22-04-x64"
  name = "k8s-node-01"
  region = "sfo3"
  size = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.zac_zac_fedora.id,
    data.digitalocean_ssh_key.zac_zacbook.id,
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
}

