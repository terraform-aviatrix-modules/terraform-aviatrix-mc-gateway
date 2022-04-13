output "vpc" {
    description = "The VPC created as an object with all attributes outputted. This is created from the aviatrix_vpc resource."
    value       = var.use_existing_vpc ? null : aviatrix_vpc.mc_vpc[0]
}
output "gateway" {
    description = "The Aviatrix gateway created, as an object with all attributes outputted."
    value       = aviatrix_gateway.gw
}