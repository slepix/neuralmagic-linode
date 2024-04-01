resource "linode_nodebalancer" "primaryregion-lb" {
    label = "deepsparse-lb-${var.primary_region}"
    region = var.primary_region
    client_conn_throttle = 0
}

resource "linode_nodebalancer_config" "primaryregion-lb-config" {
    nodebalancer_id = linode_nodebalancer.primaryregion-lb.id
    port = 80
    protocol = "http"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 30
    stickiness = "none"
    algorithm = "leastconn"
}

resource "linode_nodebalancer_node" "primary" {
    count = var.vmcount
    nodebalancer_id = linode_nodebalancer.primaryregion-lb.id
    config_id = linode_nodebalancer_config.primaryregion-lb-config.id
    address = "${element(linode_instance.neuralmagic-primary.*.private_ip_address, count.index)}:80"
    label = "nodebalancer-web-${var.primary_region}"
    weight = 100
}

