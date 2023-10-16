# Locals
locals {
  cloud                 = lower(var.cloud)
  name                  = replace(var.name, " ", "-")                     # replace space with dash
  cidr                  = var.use_existing_vpc ? "10.0.0.0/24" : var.cidr # dummy values set if existing VPC is used
  cidrbits              = tonumber(split("/", local.cidr)[1])
  newbits               = 26 - local.cidrbits
  netnum                = pow(2, local.newbits)
  insane_mode_subnet    = cidrsubnet(local.cidr, local.newbits, local.netnum - 2)
  ha_insane_mode_subnet = cidrsubnet(local.cidr, local.newbits, local.netnum - 1)

  is_china = can(regex("^cn-|^china ", lower(var.region))) && contains(["aws", "azure"], local.cloud)
  is_gov   = can(regex("^us-gov|^usgov |^usdod ", lower(var.region))) && contains(["aws", "azure"], local.cloud)

  cloud_type = local.is_china ? lookup(local.cloud_type_map_china, local.cloud, null) : (local.is_gov ? lookup(local.cloud_type_map_gov, local.cloud, null) : lookup(local.cloud_type_map, local.cloud, null))
  cloud_type_map = {
    aws   = 1,
    gcp   = 4,
    azure = 8,
    oci   = 16,
    ali   = 8192,
  }

  cloud_type_map_china = {
    aws   = 1024,
    azure = 2048,
  }

  cloud_type_map_gov = {
    azure = 32,
    aws   = 256,
  }

  region         = local.cloud == "gcp" ? "${var.region}-${local.az1}" : var.region
  zone           = local.cloud == "azure" ? local.az1 : null
  insane_mode_az = var.insane_mode ? lookup(local.insane_mode_az_map, local.cloud, null) : null
  insane_mode_az_map = {
    aws = local.cloud == "aws" ? "${var.region}${local.az1}" : null
  }

  enable_encrypt_volume = local.cloud == "aws" ? var.enable_encrypt_volume : false
  customer_managed_keys = local.cloud == "aws" && var.enable_encrypt_volume ? var.customer_managed_keys : null

  ha_zone = lookup(local.ha_zone_map, local.cloud, null)
  ha_zone_map = {
    azure = local.az2,
    gcp   = local.cloud == "gcp" ? length(var.ha_region) > 0 ? "${var.ha_region}-${local.az2}" : "${var.region}-${local.az2}" : null
  }

  ha_insane_mode_az = var.insane_mode ? lookup(local.ha_insane_mode_az_map, local.cloud, null) : null
  ha_insane_mode_az_map = {
    aws = local.cloud == "aws" ? "${var.region}${local.az2}" : null
  }

  instance_size = length(var.instance_size) > 0 ? var.instance_size : lookup(local.instance_size_map, local.cloud, null)
  instance_size_map = {
    aws   = "t3.small",
    gcp   = "n1-standard-1",
    azure = "Standard_B1ms",
    oci   = "VM.Standard2.2",
    ali   = "ecs.g5ne.large",
  }

  # Auto disable AZ support for Gov and DOD regions in Azure
  az_support = local.is_gov ? false : var.az_support

  az1 = length(var.az1) > 0 ? var.az1 : lookup(local.az1_map, local.cloud, null)
  az1_map = {
    aws   = "a",
    azure = local.az_support ? "az-1" : null,
    gcp   = "b",
  }

  az2 = length(var.az2) > 0 ? var.az2 : lookup(local.az2_map, local.cloud, null)
  az2_map = {
    aws   = "b",
    azure = local.az_support ? "az-2" : null,
    gcp   = "c",
  }

  # If using existing VPC, use specified gw subnet
  # Otherwise, if AWS/Azure Insane Mode, use insane mode subnet; if GCP, set the subnet based on the map {}. Else, set subnet as index-0 of the created VPC's subnet CIDR
  subnet = (
    (var.use_existing_vpc ?
      var.gw_subnet
      :
      (var.insane_mode && contains(["aws", "azure"], local.cloud) ?
        local.insane_mode_subnet
        :
        (local.cloud == "gcp" ?
          aviatrix_vpc.default[0].subnets[local.subnet_map[local.cloud]].cidr
          :
          aviatrix_vpc.default[0].public_subnets[local.subnet_map[local.cloud]].cidr
        )
      )
    )
  )

  subnet_map = {
    aws   = 0,
    azure = 0,
    gcp   = 0,
    oci   = 0,
    ali   = 0,
  }

  # If using existing VPC, and is Azure or OCI, set HA subnet as gw_subnet, otherwise as hagw_subnet (cont)
  # If it is AWS/Azure Insane Mode, use insane mode HA subnet; if GCP, set HA subnet based on the map {}
  # Else, set subnet based on the ha_subnet_map
  ha_subnet = (
    (var.use_existing_vpc ?
      (contains(["azure", "oci"], local.cloud) ?
        var.gw_subnet
        :
        var.hagw_subnet
      )
      :
      (var.insane_mode && contains(["aws", "azure"], local.cloud) ?
        local.ha_insane_mode_subnet
        :
        (local.cloud == "gcp" ?
          aviatrix_vpc.default[0].subnets[local.ha_subnet_map[local.cloud]].cidr
          :
          aviatrix_vpc.default[0].public_subnets[local.ha_subnet_map[local.cloud]].cidr
        )
      )
    )
  )

  ha_subnet_map = {
    aws   = 1,
    azure = 0,
    gcp   = length(var.ha_region) > 0 ? 1 : 0
    oci   = 0,
    ali   = 0,
  }

  # VPN options
  enable_elb   = var.enable_vpn && (local.cloud != "oci") ? var.enable_elb : false
  vpn_protocol = local.cloud == "oci" ? "UDP" : upper(var.vpn_protocol)

  dns_name_servers_liststring = join(",", var.dns_name_servers)
  search_domains_liststring   = join(",", var.search_domains)
  additional_cidrs_liststring = join(",", var.additional_cidrs)
}
