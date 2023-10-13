# terraform-aviatrix-mc-gateway - release notes

## v1.4.1
### Add support for AWS/Azure China/Gov regions
- Gateways can now be launched in either AWS China/Gov and Azure China/Gov regions by specifying the proper ``region`` and ``cloud``
  - ``cloud`` input should still be either "aws" or "azure" for this feature
  - ``region`` input should specify a valid AWS China/Gov or Azure China/Gov region (such as "us-gov-west-1" for AWS Gov)

## v1.4.0
### Add support for Controller 7.1 and provider version 3.1.0.

## v1.3.1
### Add support for setting custom IP addresses
- Gateway now supports specifying the public IP address for both the primary and HA instance through the use of the following variables:
  - ``allocate_new_eip``
  - ``eip``
  - ``ha_eip``
  - ``azure_eip_name_resource_group``
  - ``ha_azure_eip_name_resource_group``
- This feature is available for all the current supported CSPs: AWS, Azure, GCP, and OCI

## v1.3.0
### Add support for Controller 7.0 and provider version 3.0.0.

## v1.2.1
### Add support for setting custom IP addresses
- Gateway now supports specifying the public IP address for both the primary and HA instance through the use of the following variables:
  - ``allocate_new_eip``
  - ``eip``
  - ``ha_eip``
  - ``azure_eip_name_resource_group``
  - ``ha_azure_eip_name_resource_group``
- This feature is available for all the current supported CSPs: AWS, Azure, GCP, and OCI

## v1.2.0
### Add support for Controller 6.9 and provider version 2.24.x

## v1.1.1
### Add support for setting custom IP addresses
- Gateway now supports specifying the public IP address for both the primary and HA instance through the use of the following variables:
  - ``allocate_new_eip``
  - ``eip``
  - ``ha_eip``
  - ``azure_eip_name_resource_group``
  - ``ha_azure_eip_name_resource_group``
- This feature is available for all the current supported CSPs: AWS, Azure, GCP, and OCI

## v1.1.0
### Add support for Controller 6.8 and provider version 2.23.0.
### Add support for RX queue size for AWS gateways
- Gateway now supports specifying AWS gateways' ethernet interface RX queue size

## v1.0.4
### Add support for Advanced options for the VPC
- VPC now supports customizing the number of subnet pairs and subnet size, in addition to specify an existing Resource Group for Azure cloud
- Updated documentation for missing version notes

## v1.0.3
### Update provider constraint to 2.22.1 for the latest Controller 6.7-patch

## v1.0.2
### Add support for toggling SAML on

## v1.0.1
### Fixed versioning typo in documentation

## v1.0.0
### Initial release

This module supports launching a VPC/VNet/VCN + gateway topology, with the option to use an existing VPC
