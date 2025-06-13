
# Azure Cloud Engineer Interview Cases

This repository includes two solution designs and implementations for an Azure Cloud Engineer interview assessment.

---

Case 1: Internal Blog Website

This case demonstrates architecture design and deployment strategies for an internal blog website.

Architecture Approaches

1. **Multi-Cloud / Hybrid Approach**  
   Combines various Azure services such as:
   - Azure App Service  
   - Azure Kubernetes Service (AKS)  
   - Azure Container Instances (ACI)  
   - Virtual Machines (VMs)  

   📎 [View Architecture Diagram](https://drive.google.com/file/d/1jPap_a9QGvAc1uipyziqYZj5vfJzEKMF/view?usp=drive_link)

2. **AKS-Only Approach**  
   A fully containerized microservices architecture deployed using Azure Kubernetes Service.

   📎 [View Architecture Diagram](https://drive.google.com/file/d/1LZjQ99Vb10wLbF3pYrGQbXs1FJDCUFL4/view?usp=drive_link)

Note: These diagrams are self-created and may miss some components or flows.

---

Case 2: Self-Service Dev Environment Portal

This project aims to provide developers a self-service portal to provision and manage isolated dev environments via Azure DevOps and Terraform.

Pipeline Design

Azure DevOps pipeline includes 3 stages:

Plan ➡️ Approval Gate [Apply] ➡️ Approval Gate [Destroy]

Terraform Plan Stage - This Stage will Show a Plan after Trigeering Pipeline
TerraformApply - This Stage after Approval will Provision required Resources
TerraformDestroy - This Stage after Approval will Destroy all Resources Provisioned Earlier

- Developers trigger the pipeline with a unique `name_prefix` argument.
- This prefix is used to:
  - Create isolated workspaces
  - Provision unique resource groups and resources
  - Enforce naming conventions
- Role assignments and RBAC are managed via the `principal_object_id` variable.
- Budget alerts are configured at an 80% threshold to a predefined email group.

⚠️ Assumes all developers access resources via VPN.

---

Terraform Resources

| Resource | Description |
|---------|-------------|
| `azurerm_resource_group.marlabs_rg` | Creates a resource group (Central India) |
| `azurerm_virtual_network.marlabs_vpc` | Defines VNet (10.0.0.0/16) |
| `azurerm_subnet.marlabs_subnet` | Subnet (10.0.2.0/24) |
| `azurerm_network_interface.marlabs_nic` | NIC with dynamic private IP |
| `azurerm_linux_virtual_machine.marlabs_vm` | Ubuntu VM with password auth |
| `azurerm_network_security_group.marlabs_nsg` | NSG allowing SSH (22) and HTTP (80) |
| `azurerm_network_interface_security_group_association.marlabs_nisga` | NSG association with NIC |
| `azurerm_consumption_budget_resource_group.this` | ₹15/month budget with 80% alert |
| `azurerm_role_assignment.this` | Contributor role assignment |

Key Variables

- `name_prefix`: Prefix applied to all resource names
- `principal_object_id`: Object ID for user/group RBAC

---
 

Improvements & Notes

- The current Terraform implementation is **non-modular**, optimized for simplicity and rapid developer onboarding.
- Future improvements may include modularizing the scripts for better reusability and maintenance.
- These are dry run files and have not been tested in actual cloud and follows self driven approaches.
- Remote Backend is not Used here and can be Implemented.

