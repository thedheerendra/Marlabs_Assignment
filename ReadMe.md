
**Azure Cloud Engineer Interview Case 1: Internal Blog Website**

I have tried my best to create these Architecture Diagrams, these might miss some flows and components - 

1.Multi-cloud approach (using Azure App Service, AKS, ACI, VMs, etc.)

https://drive.google.com/file/d/1jPap_a9QGvAc1uipyziqYZj5vfJzEKMF/view?usp=drive_link

2.AKS-only approach (everything containerized)
https://drive.google.com/file/d/1LZjQ99Vb10wLbF3pYrGQbXs1FJDCUFL4/view?usp=drive_link


**Azure Cloud Engineer Interview Case 2: Self-Service Dev Environment Portal**

This is designed by keeping Dev Environment in Mind and hence I am using non moduler approach

I have created one azure devops pipeline with three stages 

Plan----->Approval Gate [Apply]----->Approval Gate [Destroy]

Whenever Some developer will trigger this pipeline, it will need a argument that will be used as identifier and prefix
A Seperate Workspace is Creted Using that Identifier and It will create a Seperate Resource Group and all Resources With Identifier Prefix
In this way we can have have multiple Resouces provissioned in parralel
this will send alert to specified group Email after 80% threshold
This also Contols role assignments which can taken care by passing principal_object_id as variable

Resource and Purpose
variable "name_prefix"  Prefix to apply to all resource names.
variable "principal_object_id"  Object ID of user/group for RBAC assignment.

azurerm_resource_group.marlabs_rg    Creates a resource group in Central India.
azurerm_virtual_network.marlabs_vpc   Defines a VNet with address space 10.0.0.0/16.
azurerm_subnet.marlabs_subnet     Creates a subnet 10.0.2.0/24 in the VNet.
azurerm_network_interface.marlabs_nic     Creates a NIC with dynamic private IP for the VM.
azurerm_linux_virtual_machine.marlabs_vm     Deploys an Ubuntu VM with password authentication.
azurerm_network_security_group.marlabs_nsg     Defines a Network Security Group (NSG) allowing SSH (22) and HTTP (80).
azurerm_network_interface_security_group_association.marlabs_nisga     Associates the NSG with the NIC.
azurerm_consumption_budget_resource_group.this     Sets a ₹15/month budget with 80% email alert.
azurerm_role_assignment.this     Assigns Contributor role to a given user/group.


Improvements-
This Terraform Script can be further modulerized but since it's Serving a Particular Purpose for Dev. I have Decided to take this Approach.

Note: I have Considered Developers are Already Using VPN


