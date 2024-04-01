output "nodebalancerip" {
  value = linode_nodebalancer.primaryregion-lb.ipv4
  description = "Nodebalancer Public IP"
}