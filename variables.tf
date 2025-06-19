# Required
variable "cloud" {
  description = "Cloud type (CSP)"
  type        = string

  validation {
    condition     = contains(["aws", "azure", "gcp", "oci", "ali"], lower(var.cloud))
    error_message = "Invalid cloud type. Choose AWS, Azure, GCP, OCI or Ali."
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

variable "allocate_new_eip" {
  description = "Set to false to reuse an idle address in Elastic IP pool for this gateway. Otherwise, allocate a new Elastic IP and use it for this gateway"
  type        = bool
  default     = true
}

variable "eip" {
  description = "Required when allocate_new_eip is false. It uses the specified EIP for this gateway"
  type        = string
  default     = null
}

variable "ha_eip" {
  description = "Required when allocate_new_eip is false. It uses the specified EIP for this HA gateway"
  type        = string
  default     = null
}

variable "azure_eip_name_resource_group" {
  description = "Name of public IP Address resource and its resource group in Azure to be assigned to the gateway instance"
  type        = string
  default     = null
}

variable "ha_azure_eip_name_resource_group" {
  description = "Name of public IP Address resource and its resource group in Azure to be assigned to the HA gateway instance"
  type        = string
  default     = null
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

variable "rx_queue_size" {
  description = "Gateway ethernet interface RX queue size. Once set, can't be deleted or disabled. For AWS only."
  type        = string
  default     = null
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

variable "gw_amount" {
  description = "Amount of gateways to be created."
  type        = number
  default     = 1
  nullable    = false
}

variable "custom_elb_name" {
  description = "Set to true to use custom ELB name. If false, the module will set elb_name to `null`."
  type        = bool
  default     = true
}

