# Required
variable "cloud" {
  description = "Cloud type (CSP)"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "oci", "gcp"], lower(var.cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP or OCI."
  }
}

variable "name" {
  description = "Name of VPC and gateway"
  type        = string

  validation {
    condition     = length(var.name) <= 50
    error_message = "Name is too long. Max length is 50 characters."
  }
}

variable "region" {
  description = "Region to deploy module in"
  type        = string
}

variable "cidr" {
  description = "CIDR range of the VPC to be created"
  type        = string
  default     = ""

  validation {
    condition     = var.cidr != "" ? can(cidrnetmask(var.cidr)) : true
    error_message = "This is not a valid CIDR."
  }
}

variable "account" {
  description = "Aviatrix access account name in the Aviatrix controller"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain for OCI gateway to be launched in. Required for OCI"
  type        = string
  default     = ""
}

variable "fault_domain" {
  description = "Fault domain for OCI gateway to be launched in. Required for OCI"
  type        = string
  default     = ""
}

# Optional
## HA options
variable "single_az_ha" {
  description = "Set to true to enable Controller-managed gateway HA feature"
  type        = bool
  default     = true
}

variable "enable_ha" {
  description = "Set this to true, to enable HA for this gateway module"
  type        = bool
  default     = false
}

variable "hagw_subnet" {
  description = "Subnet CIDR of an existing VPC, to launch the HA gateway in"
  type        = string
  default     = ""

  validation {
    condition     = var.hagw_subnet != "" ? can(cidrnetmask(var.hagw_subnet)) : true
    error_message = "This is not a valid CIDR."
  }
}

variable "ha_availability_domain" {
  description = "Availability domain for OCI HA gateway to be launched in. Required for OCI if HA is enabled"
  type        = string
  default     = ""
}

variable "ha_fault_domain" {
  description = "Fault domain for OCI HA gateway to be launched in. Required for OCI if HA is enabled"
  type        = string
  default     = ""
}

variable "ha_cidr" {
  description = "CIDR range of the HA GCP subnet"
  type        = string
  default     = ""

  validation {
    condition     = var.ha_cidr != "" ? can(cidrnetmask(var.ha_cidr)) : true
    error_message = "This is not a valid CIDR."
  }
}

variable "ha_region" {
  description = "Secondary GCP region where subnet and HA gateway will be launched in"
  type        = string
  default     = ""
}

## GW options
variable "use_existing_vpc" {
  description = "Set to true to use existing VPC instead of creating new one"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID of an existing VPC, for the gateway to be launched in"
  type        = string
  default     = ""
}

variable "gw_subnet" {
  description = "Subnet CIDR of existing VPC. Required when use_existing_vpc is true"
  type        = string
  default     = ""

  validation {
    condition     = var.gw_subnet != "" ? can(cidrnetmask(var.gw_subnet)) : true
    error_message = "This is not a valid CIDR."
  }
}

variable "instance_size" {
  description = "Instance size for Aviatrix gateway"
  type        = string
  default     = ""
}

variable "enable_encrypt_volume" {
  description = "Set to true to enable encryption of the EBS volume of the gateway(s). Only for AWS clouds"
  type        = bool
  default     = true
}

variable "customer_managed_keys" {
  description = "AWS Customer-managed key ID"
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Map of tags for the gateway to be created"
  type        = map(string)
  default     = null
}

variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a. Only used for Insane mode"
  type        = string
  default     = ""
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b. Only used for Insane mode"
  type        = string
  default     = ""
}

variable "az_support" {
  description = "Set to true if the Azure region supports AZ's"
  type        = bool
  default     = true
}

## Advanced options
variable "insane_mode" {
  description = "Set to true to enable Aviatrix high performance encryption. Only supported for AWS and Azure"
  type        = bool
  default     = false
}

variable "single_ip_snat" {
  description = "Set to true to enable Source NAT feature in single_ip mode for the gateway. Please disable AWS NAT instance before enabling. Only supported for AWS and Azure"
  type        = bool
  default     = false
}

variable "subnet_size" {
  description = "Size of each cidr block in bits"
  type        = number
  default     = null
}

variable "num_of_subnet_pairs" {
  description = "Number of public subnet and private subnet pair created in the VPC"
  type        = number
  default     = null
}

variable "resource_group" {
  description = "The name of an existing resource group or a new resource group to be created for the Azure VNet"
  type        = string
  default     = ""
}

## VPN options
variable "enable_vpn" {
  description = "Set to true to enable user access through VPN to this gateway"
  type        = bool
  default     = false
}

variable "vpn_cidr" {
  description = "VPN CIDR block for the gateway. Required only if gateway is VPN-enabled"
  type        = string
  default     = "192.168.43.0/24"

  validation {
    condition     = var.vpn_cidr != "" ? can(cidrnetmask(var.vpn_cidr)) : true
    error_message = "This is not a valid CIDR."
  }
}

variable "enable_elb" {
  description = "Set to true to enable ELB for VPN-enabled gateway. Not available for OCI"
  type        = bool
  default     = true
}

variable "max_vpn_connections" {
  description = "Maximum number of active VPN users allowed to be connected to VPN-enabled gateway"
  type        = number
  default     = 100
}

variable "vpn_protocol" {
  description = "Transport mode for VPN connection. All cloud_types support TCP with ELB, and UDP without ELB. AWS(1) additionally supports UDP with ELB"
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP"], upper(var.vpn_protocol))
    error_message = "Invalid VPN protocol. Choose TCP or UDP."
  }
}

variable "enable_vpn_nat" {
  description = "Set to true to enable VPN NAT. Only for VPN-enabled gateway"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Value (in seconds) of idle timeout. If set, must be greater than 300; if unset, this feature is disabled. Only for VPN-enabled gateway"
  type        = number
  default     = -1
}

variable "renegotiation_interval" {
  description = "Value (in seconds) of the renegotiation interval. If set, must be greater than 300; if unset, this feature is disabled. Only for VPN-enabled gateway"
  type        = number
  default     = -1
}

## Split Tunnel options
variable "enable_split_tunnel_mode" {
  description = "Set to true to enable Split Tunnel Mode"
  type        = bool
  default     = true
}

variable "dns_name_servers" {
  description = "List of DNS servers to use to resolve domain names by VPN users, connected to a VPN-enabled Split-Tunnel-enabled gateway"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "search_domains" {
  description = "List of domain names that will use the Nameserver when specific name not in destination. Only for VPN-enabled Split-Tunnel-enabled gateways"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "additional_cidrs" {
  description = "List of destination CIDR ranges that will also go through VPN tunnel. Only for VPN-enabled Split-Tunnel-enabled gateways"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "saml_enabled" {
  description = "Enable/disable SAML."
  type        = bool
  default     = null
}

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

  cloud_type = lookup(local.cloud_type_map, local.cloud, null)
  cloud_type_map = {
    aws   = 1,
    gcp   = 4,
    azure = 8,
    oci   = 16
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
    oci   = "VM.Standard2.2"
  }

  num_of_subnet_pairs = var.num_of_subnet_pairs != null ? var.num_of_subnet_pairs : lookup(local.num_of_subnet_pairs_map, local.cloud, null)
  num_of_subnet_pairs_map = {
    azure = 2,
    aws   = 2,
  }

  subnet_size = var.subnet_size != null ? var.subnet_size : lookup(local.subnet_size_map, local.cloud, null)
  subnet_size_map = {
    azure = 28,
    aws   = 28,
  }

  az1 = length(var.az1) > 0 ? var.az1 : lookup(local.az1_map, local.cloud, null)
  az1_map = {
    aws   = "a",
    azure = var.az_support ? "az-1" : null,
    gcp   = "b",
  }

  az2 = length(var.az2) > 0 ? var.az2 : lookup(local.az2_map, local.cloud, null)
  az2_map = {
    aws   = "b",
    azure = var.az_support ? "az-2" : null,
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
  }

  # VPN options
  enable_elb   = var.enable_vpn && (local.cloud != "oci") ? var.enable_elb : false
  vpn_protocol = local.cloud == "oci" ? "UDP" : upper(var.vpn_protocol)

  dns_name_servers_liststring = join(",", var.dns_name_servers)
  search_domains_liststring   = join(",", var.search_domains)
  additional_cidrs_liststring = join(",", var.additional_cidrs)
}
