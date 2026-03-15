
# https://oneuptime.com/blog/post/2026-02-21-terraform-outputs-ansible-inventory/view

# terraform/inventory.tf - Generate inventory as a Terraform resource

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../inventory.template.yaml", {
    k8s_node_01 = digitalocean_droplet.k8s-node-01
    k8s_node_02 = digitalocean_droplet.k8s-node-02
    k8s_node_03 = digitalocean_droplet.k8s-node-03
  })
  filename = "${path.module}/../inventory.yaml"
}
