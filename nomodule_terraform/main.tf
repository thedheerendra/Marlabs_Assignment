variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "principal_object_id" {
  description = "The object ID of the user or group to assign access"
  type        = string
  default = "None"
}

resource "azurerm_resource_group" "marlabs_rg" {
  name     = "${var.name_prefix}-marlaba-dev-rg"
  location = "Central India"
}

resource "azurerm_virtual_network" "marlabs_vpc" {
  name                = "${var.name_prefix}-marlabs-dev-vpc"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.marlabs_rg.location
  resource_group_name = azurerm_resource_group.marlabs_rg.name
}

resource "azurerm_subnet" "marlabs_subnet" {
  name                 = "${var.name_prefix}-marlabs-dev-subnet"
  resource_group_name  = azurerm_resource_group.marlabs_rg.name
  virtual_network_name = azurerm_virtual_network.marlabs_vpc.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "marlabs_nic" {
  name                = "${var.name_prefix}-marlabs-dev-nic"
  location            = azurerm_resource_group.marlabs_rg.location
  resource_group_name = azurerm_resource_group.marlabs_rg.name

  ip_configuration {
    name                          = "ip"
    subnet_id                     = azurerm_subnet.marlabs_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "marlabs_vm" {
  name                = "${var.name_prefix}-marlabs-dev-vm"
  resource_group_name = azurerm_resource_group.marlabs_rg.name
  location            = azurerm_resource_group.marlabs_rg.location
  size                = "Standard_D2as_v5"
  admin_username      = "adminuser"
  admin_password      = "12345@abcD"
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.marlabs_nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_network_security_group" "marlabs_nsg" {
  name                = "${var.name_prefix}-marlabs-dev-nsg"
  location            = azurerm_resource_group.marlabs_rg.location
  resource_group_name = azurerm_resource_group.marlabs_rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "marlabs_nisga" {
  network_interface_id      = azurerm_network_interface.marlabs_nic.id
  network_security_group_id = azurerm_network_security_group.marlabs_nsg.id
}

resource "azurerm_consumption_budget_resource_group" "this" {
  name              = "${var.name_prefix}-marlabs-dev-budget"
  resource_group_id = azurerm_resource_group.marlabs_rg.name
  amount            = 15    # Set your budget amount
  time_grain        = "Monthly"

  time_period {
    start_date = "2025-06-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    contact_emails = ["email@example.com"]
  }
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_resource_group.marlabs_rg.name
  role_definition_name = "Contributor"
  principal_id         = var.principal_object_id  # Pass this as a variable
}