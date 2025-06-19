# Usage Examples

This document contains examples on how to launch this module with various configurations (including using optional arguments).

For full details on available attributes, please see the README.md

## Launching a full module with HA

The following examples will launch a new VPC + gateway with HA and Insane Mode (where applicable)

```
# AWS
module "aws_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "aws"
    name    = "foo-aws"
    region  = "us-east-1"
    cidr    = "10.11.0.0/16"
    account = "AWS-Devops"

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# Azure
module "arm_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "azure"
    name    = "foo-azure"
    region  = "Central US"
    cidr    = "10.12.0.0/16"
    account = "Azure-Devops"
    instance_size = "Standard_D3_v2" # note Insane Mode supports specific instance sizes

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# GCP
module "gcp_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "gcp"
    name    = "foo-gcp"
    region  = "us-central1"
    cidr    = "10.13.0.0/16"
    account = "GCP-Devops"

    # note specifying HA options here will create HA subnet + HAGW within for GCP
    enable_ha   = true
    ha_cidr     = "10.14.0.0/16"
    ha_region   = "us-east1"
}
```
```
# OCI
module "oci_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "oci"
    name    = "foo-oci"
    region  = "us-ashburn-1"
    cidr    = "10.15.0.0/16"
    account = "OCI-Devops"
    
    # note OCI requires AD and FD values
    availability_domain = "US-ASHBURN-AD-1"
    fault_domain        = "FAULT-DOMAIN-1"

    enable_ha               = true
    ha_availability_domain  = "US-ASHBURN-AD-2"
    ha_fault_domain         = "FAULT-DOMAIN-2"
}
```
```
# AWS Gov
module "aws_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "aws"
    name    = "foo-aws-gov"
    region  = "us-gov-west-1"
    cidr    = "10.16.0.0/16"
    account = "AWSGov-Devops"

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# AWS China
module "aws_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "aws"
    name    = "foo-aws-china"
    region  = "cn-north-1"
    cidr    = "10.17.0.0/16"
    account = "AWSChina-Devops"

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# Azure Gov
module "arm_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "azure"
    name    = "foo-azure-gov"
    region  = "USGov Virginia"
    cidr    = "10.18.0.1/16"
    account = "AzureGov-Devops"
    instance_size = "Standard_D3_v2" # note Insane Mode supports specific instance sizes

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# Azure China
module "arm_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "azure"
    name    = "foo-azure-china"
    region  = "China East"
    cidr    = "10.19.0.0/16"
    account = "AzureChina-Devops"
    instance_size = "Standard_D3_v2" # note Insane Mode supports specific instance sizes

    # optional
    enable_ha   = true
    insane_mode = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# Alibaba
module "ali_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "ali"
    name    = "foo-ali"
    region  = "acs-us-west-1 (Silicon Valley)"
    cidr    = "10.20.0.0/16"
    account = "Ali-Devops"

    # optional
    enable_ha   = true
}
```

## Launching module with an existing VPC/VNet/VCN

The following examples will launch a gateway with HA, in an existing VPC/VNet/VCN

```
# AWS
module "aws_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "aws"
    name    = "foo-aws"
    account = "AWS-Devops"

    use_existing_vpc    = true
    vpc_id              = "vpc-abc123"
    region              = "us-east-1"
    gw_subnet           = "10.0.2.0/24"
    hagw_subnet         = "10.0.3.0/24"

    enable_ha = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# Azure
module "arm_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "azure"
    name    = "foo-azure"
    account = "Azure-Devops"

    use_existing_vpc    = true
    vpc_id              = "VNet:ResourceGroup:Resource-GUID"
    region              = "Central US"
    gw_subnet           = "10.3.0.0/24"
    hagw_subnet         = "10.3.0.0/24"

    enable_ha = true
    tags = {
        "owner" = "bar"
    }
}
```
```
# GCP
module "gcp_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "gcp"
    name    = "foo-gcp"
    account = "GCP-Devops"

    use_existing_vpc    = true
    vpc_id              = "gcp-foo-vpc"
    region              = "us-central1"
    gw_subnet           = "10.128.0.1/20"
    hagw_subnet         = "10.142.0.0/20"

    enable_ha = true
}
```
```
# OCI
module "oci_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "oci"
    name    = "foo-oci"
    account = "OCI-Devops"

    use_existing_vpc    = true
    vpc_id              = "OCI-VCN"
    region              = "us-ashburn-1"
    gw_subnet           = "123.101.0.0/16"
    hagw_subnet         = "123.101.0.0/16"
    availability_domain = "US-ASHBURN-AD-1"
    fault_domain        = "FAULT-DOMAIN-1"

    enable_ha = true
    ha_availability_domain  = "US-ASHBURN-AD-2"
    ha_fault_domain         = "FAULT-DOMAIN-2"
}
```

## Launching VPN gateway module

The following examples will launch a VPC + VPN gateway, with some sample VPN configurations

```
# AWS
module "aws_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "aws"
    name    = "foo-aws"
    region  = "us-east-1"
    cidr    = "10.11.0.0/16"
    account = "AWS-Devops"

    tags = {
        "owner" = "bar"
    }

    # VPN
    enable_vpn              = true
    vpn_cidr                = "192.168.50.0/24"
    enable_elb              = true
    vpn_protocol            = "UDP"
    max_vpn_connections     = 50
    idle_timeout            = 301
    renegotiation_interval  = 301

    enable_split_tunnel_mode    = true
    dns_name_servers            = ["1.1.1.1", "199.85.126.10"]
    search_domains              = ["https://duckduckgo.com/", "https://www.google.com"]
    additional_cidrs            = ["10.11.0.0/16", "10.12.0.0/32"]
}
```
```
# Azure
module "arm_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "azure"
    name    = "foo-azure"
    region  = "Central US"
    cidr    = "10.12.0.0/16"
    account = "Azure-Devops"

    tags = {
        "owner" = "bar"
    }

    # VPN
    enable_vpn              = true
    vpn_cidr                = "192.168.51.0/24"
    enable_elb              = true
    vpn_protocol            = "TCP"
    max_vpn_connections     = 50
    idle_timeout            = 301
    renegotiation_interval  = 301

    enable_split_tunnel_mode    = true
    dns_name_servers            = ["1.1.1.1", "199.85.126.10"]
    search_domains              = ["https://duckduckgo.com/", "https://www.google.com"]
    additional_cidrs            = ["10.11.0.0/16", "10.12.0.0/32"]
}
```
```
# GCP
module "gcp_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "gcp"
    name    = "foo-gcp"
    region  = "us-central1"
    cidr    = "10.13.0.0/16"
    account = "GCP-Devops"

    # VPN
    enable_vpn              = true
    vpn_cidr                = "192.168.52.0/24"
    enable_elb              = false
    vpn_protocol            = "UDP" # only when ELB = false
    max_vpn_connections     = 50
    idle_timeout            = 301
    renegotiation_interval  = 301

    enable_split_tunnel_mode    = true
    dns_name_servers            = ["1.1.1.1", "199.85.126.10"]
    search_domains              = ["https://duckduckgo.com/", "https://www.google.com"]
    additional_cidrs            = ["10.11.0.0/16", "10.12.0.0/32"]
}
```
```
# OCI
module "oci_gw_module" {
    source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
    version = "8.0.1"

    cloud   = "oci"
    name    = "foo-oci"
    region  = "us-ashburn-1"
    cidr    = "10.15.0.0/16"
    account = "OCI-Devops"
    availability_domain = "US-ASHBURN-AD-1"
    fault_domain        = "FAULT-DOMAIN-1"

    # VPN
    enable_vpn              = true
    vpn_cidr                = "192.168.53.0/24"
    vpn_protocol            = "UDP"
    max_vpn_connections     = 50
    idle_timeout            = 301
    renegotiation_interval  = 301

    enable_split_tunnel_mode    = true
    dns_name_servers            = ["1.1.1.1", "199.85.126.10"]
    search_domains              = ["https://duckduckgo.com/", "https://www.google.com"]
    additional_cidrs            = ["10.11.0.0/16", "10.12.0.0/32"]
}
```