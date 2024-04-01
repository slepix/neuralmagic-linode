resource "linode_instance" "neuralmagic-primary" {
    count = var.vmcount
    label = "deepsparse-${var.primary_region}-${count.index + 1}"
    image = "linode/ubuntu22.04"
    region = var.primary_region
    type = "g6-dedicated-2"
    root_pass = "Terr4form-test!" #Change this!
    tags = [ "app:sentimentanalysis" ]
    private_ip = true
  

  metadata {
    user_data = "${base64encode(file("./linode.yaml"))}"
  }
}