# terraform-aviatrix-mc-gateway

## Description

Deploys a VPC/VNet/VCN and Aviatrix gateway. It is also possible to use an existing VPC/VNet/VCN.

## Compatibility

| Module version | Terraform version | Controller version | Terraform provider version |
| :------------: | :---------------: | :----------------: | :------------------------: |
|     v1.0.2     |     >=1.0         |       >=6.7        |          ~>2.22.0          |
|     v1.0.1     |     0.13-1.x      |       >=6.7        |           2.22.0           |
|     v1.0.0     |     0.13-1.x      |       >=6.6        |       2.21.2-6.6.ga        |

- Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-gateway/blob/master/RELEASE_NOTES.md) for more details.

## Usage examples

See [examples](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-gateway/blob/main/examples/)

## Variables

The following variables are required:

|      Attribute      |                                       Description                                        |
| :-----------------: | :--------------------------------------------------------------------------------------: |
|        cloud        |      Cloud where this will be deployed. Valid values: "AWS", "GCP", "Azure", "OCI"       |
|        name         |                       Name for this VPC/VNet/VCN and its gateways                        |
|       region        |                       Cloud region to deploy this VPC/VNet/VCN in                        |
|        cidr         | What IP CIDR to use for this VPC/VNet/VCN (Not required when `use_existing_vpc` is true) |
|       account       |                   The account name as known by the Aviatrix controller                   |
| availability_domain |           Availability domain for OCI gateway to be launched in (only for OCI)           |
|    fault_domain     |              Fault domain for OCI gateway to be launched in (only for OCI)               |

The following variables are optional:

### HA options

|       Attribute        | Supported CSPs |                        Default value                         |                                           Description                                            |
| :--------------------: | :------------: | :----------------------------------------------------------: | :----------------------------------------------------------------------------------------------: |
|     instance_size      |      ALL       | t3.small<br>n1-standard-1<br>Standard_B1ms<br>VM.Standard2.2 |                                Instance size for Aviatrix gateway                                |
|      single_az_ha      |      ALL       |                             true                             |                   Set to true to enable Controller-managed gateway HA feature                    |
|       enable_ha        |      ALL       |                            false                             |                    Set to true to enable HA and deploy a primary + HA gateway                    |
| ha_availability_domain |      OCI       |                                                              |            Availability domain for OCI HA gateway. Required for OCI if HA is enabled             |
|    ha_fault_domain     |      OCI       |                                                              |                Fault domain for OCI HA gateway. Required for OCI if HA is enabled                |
|        ha_cidr         |      GCP       |                                                              |           IP CIDR to be used to create the HA region subnet. Required if HA is enabled           |
|       ha_region        |      GCP       |                                                              | Region for multi-region HA. Secondary GCP region where subnet and HA gateway will be launched in |

### GW options

|       Attribute       |   Supported CSPs    | Default value  |                                                Description                                                 |
| :-------------------: | :-----------------: | :------------: | :--------------------------------------------------------------------------------------------------------: |
|   use_existing_vpc    |         ALL         |     false      |                        Set to true to use an existing VPC instead of launching one                         |
|        vpc_id         |         ALL         |                |          VPC ID of an existing VPC, to launch gateway in. Required if `use_existing_vpc` is true           |
|       gw_subnet       |         ALL         |                |        Subnet CIDR of an existing VPC, to launch gateway in. Required if `use_existing_vpc` is true        |
|      hagw_subnet      |         ALL         |                | Subnet CIDR of existing VPC, to launch HA gateway in. Required if `enable_ha` & `use_existing_vpc` is true |
| enable_encrypt_volume |         AWS         |      true      |                    Set to true to enable encryption of the EBS volume of the gateway(s)                    |
| customer_managed_keys |         AWS         |                |                     AWS customer-managed key ID, to be used to encrypt the EBS volume                      |
|         tags          |    AWS<br>Azure     |                |                                    Map of tags to assign to the gateway                                    |
|          az1          | AWS<br>Azure<br>GCP | a<br>az-1<br>b |           Concatenate with region to form az names. eg. eu-central-1a. Used for Insane Mode only           |
|          az2          | AWS<br>Azure<br>GCP | b<br>az-2<br>c |           Concatenate with region to form az names. eg. eu-central-1b. Used for Insane Mode only           |
|      az_support       |        Azure        |      true      |                                 Set to true if Azure region supports AZ's                                  |

### Advanced options

|      Attribute      | Supported CSPs | Default value |                                                               Description                                                               |
| :-----------------: | :------------: | :-----------: | :-------------------------------------------------------------------------------------------------------------------------------------: |
|     insane_mode     |  AWS<br>Azure  |     false     |                                       Set to true to enable Aviatrix high performance encryption                                        |
|   single_ip_snat    |      ALL       |     false     | Set to true to enable Source NAT feature in single_ip mode on the gateway. Please disable AWS NAT instance before enabling this feature |
| num_of_subnet_pairs |      ALL       |               |                        Number of public subnet and private subnet pair created. Only Support AWS, Azure Provider                        |
|     subnet_size     |      ALL       |               |                                           Subnet Size. Only Supported for AWS, Azure Provider                                           |
|   resource_group    |      ALL       |               |                         Name of an existing resource group or a new resource group to be created for Azure VNet                         |

### VPN options

|       Attribute        |   Supported CSPs    |  Default value  |                                                                     Description                                                                      |
| :--------------------: | :-----------------: | :-------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------: |
|       enable_vpn       |         ALL         |      false      |                                            Set to true to enable user access through VPN to this gateway                                             |
|        vpn_cidr        |         ALL         | 192.168.43.0/24 |                                                            VPN CIDR block for the gateway                                                            |
|       enable_elb       | AWS<br>Azure<br>GCP |      true       |                                      Set to true to create ELB with VPN-enabled gateway. Not available for OCI                                       |
|  max_vpn_connections   |         ALL         |       100       |                                  Maximum number of active VPN usersr allowed to be connected to VPN-enabled gateway                                  |
|      vpn_protocol      |         ALL         |       TCP       |       Transport mode for VPN connection. All cloud_types support TCP with ELB, and UDP without ELB. AWS(1) additionally supports UDP with ELB        |
|     enable_vpn_nat     |         ALL         |      true       |                                             Set to true to enable VPN NAT. Only for VPN-enabled gateway                                              |
|      idle_timeout      |         ALL         |       -1        |        Value (in seconds) of idle timeout. If set, must be greater than 300; if unset, this feature is disabled. Only for VPN-enabled gateway        |
| renegotiation_interval |         ALL         |       -1        | Value (in seconds) of the renegotiation interval. If set, must be greater than 300; if unset, this feature is disabled. Only for VPN-enabled gateway |
|     saml_enabled       |         ALL         |      false      |                                                                  Enable/disable SAML.                                                                |

#### Split Tunnel options

|        Attribute         | Supported CSPs | Default value |                                                                                 Description                                                                                  |
| :----------------------: | :------------: | :-----------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| enable_split_tunnel_mode |      ALL       |     true      |                                               Set to true to enable Split Tunnel Mode. Only available for VPN-enabled gateways                                               |
|     dns_name_servers     |      ALL       |      []       |                  List of DNS servers to use to resolve domain names by VPN users, connected to a VPN-enabled Split-Tunnel-enabled gateway. eg. ["1.1.1.1"]                   |
|      search_domains      |      ALL       |      []       | List of domain names that will use the Nameserver when specific name not in destination. Only for VPN-enabled Split-Tunnel-enabled gateways. eg. ["https://wwww.google.com"] |
|     additional_cidrs     |      ALL       |      []       |                List of destination CIDR ranges that will also go through VPN tunnel. Only for VPN-enabled Split-Tunnel-enabled gateways. eg. ["10.0.0.0/16"]                 |

## Outputs

This module will return the following outputs:

|   Key   |                                                                Description                                                                |
| :-----: | :---------------------------------------------------------------------------------------------------------------------------------------: |
|   vpc   | The created VPC as an object with all its attributes (when `use_existing_vpc` is false). This was created using the aviatrix_vpc resource |
| gateway |                                     The created Aviatrix gateway as an object with all its attributes                                     |
