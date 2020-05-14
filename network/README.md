#Network configuration module

This module creates a VPC with the following content:
* A VPC with an address block range given by var.cidr_range
* A gateway and application subnet range
* A NAT gateway and internet gateway attached to the gateway subnet


###Arguments
| Variables | Description |
|:-------|:--------|
| cidr_range | The address block range to use for the VPC
| aws_region | Aws region to deploy the VPC to
| subnet_count | Number of subnets to generate the network over
| cluster-name | Used by subnets to correctly tag the name

###Outputs
|Output|Description|
|:-----|:----------|
|vpc_id|The associated VPC identifier|
|application_subnet_ids|tuple containing all application subnet ids
