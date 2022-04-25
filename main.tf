resource "aviatrix_vpc" "mc_vpc" {
  count = var.use_existing_vpc ? 0 : 1

  cloud_type   = local.cloud_type
  account_name = var.account
  region       = local.cloud == "gcp" ? null : var.region
  cidr         = local.cloud == "gcp" ? null : var.cidr
  name         = local.name

  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  # subnet_size = 
  # num_subnet_pairs = 
  # resource_group = 

  dynamic "subnets" {
    for_each = local.cloud == "gcp" ? ["dummy"] : [] # Workaround to make block conditional. Count not available on dynamic blocks
    content {
      name   = local.name
      cidr   = var.cidr
      region = var.region
    }
  }

  dynamic "subnets" {
    for_each = local.cloud == "gcp" && length(var.ha_region) > 0 ? ["dummy"] : []
    content {
      name   = "${local.name}-ha"
      cidr   = var.ha_cidr
      region = var.ha_region
    }
  }
}

resource "aviatrix_gateway" "gw" {
  cloud_type          = local.cloud_type
  account_name        = var.account
  vpc_id              = var.use_existing_vpc ? var.vpc_id : aviatrix_vpc.mc_vpc[0].vpc_id
  vpc_reg             = local.region
  subnet              = local.subnet
  gw_name             = local.name
  gw_size             = local.instance_size
  availability_domain = local.cloud == "oci" ? var.availability_domain : null
  fault_domain        = local.cloud == "oci" ? var.fault_domain : null
  zone                = local.zone

  # HA options
  single_az_ha                   = var.single_az_ha
  peering_ha_subnet              = var.enable_ha ? local.ha_subnet : null
  peering_ha_gw_size             = var.enable_ha ? local.instance_size : null
  peering_ha_availability_domain = var.enable_ha && (local.cloud == "oci") ? var.ha_availability_domain : null
  peering_ha_fault_domain        = var.enable_ha && (local.cloud == "oci") ? var.ha_fault_domain : null
  peering_ha_zone                = var.enable_ha ? local.ha_zone : null

  # Advanced options
  enable_encrypt_volume = local.enable_encrypt_volume
  customer_managed_keys = local.customer_managed_keys
  tags                  = var.tags

  single_ip_snat = var.single_ip_snat

  insane_mode               = var.insane_mode
  insane_mode_az            = local.insane_mode_az
  peering_ha_insane_mode_az = var.enable_ha ? local.ha_insane_mode_az : null

  # VPN options
  vpn_access     = var.enable_vpn
  vpn_cidr       = var.enable_vpn ? var.vpn_cidr : null
  vpn_protocol   = var.enable_vpn ? local.vpn_protocol : null
  max_vpn_conn   = var.enable_vpn ? var.max_vpn_connections : null
  enable_vpn_nat = var.enable_vpn ? var.enable_vpn_nat : null
  enable_elb     = local.enable_elb
  elb_name       = local.enable_elb ? "${local.name}-elb" : null

  idle_timeout           = var.enable_vpn && (var.idle_timeout > 300) ? var.idle_timeout : null
  renegotiation_interval = var.enable_vpn && (var.renegotiation_interval > 300) ? var.renegotiation_interval : null

  # Split Tunnel options
  split_tunnel     = var.enable_vpn ? var.enable_split_tunnel_mode : null
  name_servers     = var.enable_vpn && var.enable_split_tunnel_mode ? local.dns_name_servers_liststring : null
  search_domains   = var.enable_vpn && var.enable_split_tunnel_mode ? local.search_domains_liststring : null
  additional_cidrs = var.enable_vpn && var.enable_split_tunnel_mode ? local.additional_cidrs_liststring : null
}