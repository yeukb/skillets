variable "resource_group_name" {
    default = "JIT-outbound-rg"
}

variable "location" {
    default = "southeastasia"
}

variable "virtualNetworkName" {
    default = "NET-Demo"
}

variable "virtualNetworkAddressPrefix" {
    default = "10.0.0.0/16"
}

variable "managementSubnetName" {
    default = "Management"
}

variable "managementSubnetAddressPrefix" {
    default = "10.0.0.0/24"
}

variable "untrustSubnetName" {
    default = "Untrust"
}

variable "untrustSubnetAddressPrefix" {
    default = "10.0.1.0/24"
}

variable "trustSubnetName" {
    default = "Trust"
}

variable "trustSubnetAddressPrefix" {
    default = "10.0.2.0/24"
}

variable "protectedSubnetName" {
    default = "Dev"
}

variable "protectedSubnetAddressPrefix" {
    default = "10.0.3.0/24"
}

variable "vmSize" {
    default = "Standard_D3_v2"
}

variable "imageSku" {
    default = "byol"
}

variable "imageVersion" {
    default = "latest"
}

variable "bootstrap" {
    default = "yes"
}

variable "customdata" {
    default = "storage-account=<Azure File Share Name>,access-key=<>Access Key,file-share=bootstrap,share-directory=None"
}

variable "adminUsername" {
    default = "paloalto"
}

variable "adminPassword" {
    default = "PaloAlt0123!"
}

variable "AllowedSourceIPRange" {
    default = "0.0.0.0/0"
}

variable "egressLBFrontEndAddress" {
    default = "10.0.2.100"
}




