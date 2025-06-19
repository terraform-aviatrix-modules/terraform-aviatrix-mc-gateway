# terraform-aviatrix-mc-gateway - release notes

## v8.0.1
- Automatically disables az_support if region is Azure China.

## v8.0.0
### Version Alignment
Starting with this release, this Terraform module will align its version with the Aviatrix Controller version. This means the module version has jumped from v1.7.1 to v8.0.0 to align with the Controller’s latest major version. This change makes it easier to determine which module version is compatible with which Controller version.

### Relaxed version constraints
Starting with this release, this Terraform module will move from a pessimistic constraint operator (`~>`) to a more relaxed provider version constraint (`>=`). As a result of this, module versions 8.0.0 and above can be used with newer (future) version of the Aviatrix Terraform provider, with the constraint that the newer provider version cannot have behavioral changes.
The reason for this change is to allow users to upgrade their controller and Terraform provider versions, without requiring to upgrade all their Terraform module versions, unless any of the following exceptions are true:
- User requires access to new feature flags, that are only exposed in newer Terraform module versions.
- The new Terraform provider version does not introduce behavior changes that are incompatible with the module version.

### Future releases
A new major module version will be released _only_ when:
- A new major Aviatrix Terraform provider has been released AND introduces new features or breaking changes.

A new minor module version will be released when:
- Bug fixes or missed features that were already available in the same release train as the Aviatrix Terraform provider.


## v1.4.2
### Make amount of gateways variable.
Using the variable `gw_amount`, users can now set the amount of gateways they want to create. The default is 1. This is particularly useful for multiple uservpn gateways.
It automatically alternates over two subnets in different AZ's.

## v1.4.1
### Add support for AWS/Azure China/Gov regions
- Gateways can now be launched in either AWS China/Gov and Azure China/Gov regions by specifying the proper ``region`` and ``cloud``
  - ``cloud`` input should still be either "aws" or "azure" for this feature
  - ``region`` input should specify a valid AWS China/Gov or Azure China/Gov region (such as "us-gov-west-1" for AWS Gov)
### Add support for Alibaba Cloud
- Gateways can now be launched in Alibaba Cloud
  - ``cloud`` input should be "Ali" (case-insensitive)
  - ``region`` input should specify a valid Alibaba Cloud region (full name including the '()')
  - ``instance_size`` input should specify a valid Alibaba Cloud instance size. New default is "ecs.g5ne.large"

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
