variable "access_key" {
    default = ""
}

variable "secret_key" {
    default = ""
}

variable "fw-region" {
    default = "ap-southeast-1"
}


variable "fw-vpc" {
    default = "FW-VPC"
}


variable "fw-vpc-cidr" {
    default = "10.88.0.0/16"
}



variable "fw-vswitch-mgmt-cidr" {
    default = "10.88.0.0/24"
}



variable "fw-vswitch-untrust-cidr" {
    default = "10.88.1.0/24"
}



variable "fw-vswitch-trust-cidr" {
    default = "10.88.2.0/24"
}



variable "instance-type" {
    default = "ecs.sn2ne.xlarge"
}



variable "instance-name" {
    default = "FW-VM"
}



variable "MGMT-IP" {
    default = "10.88.0.10"
}



variable "UNTRUST-IP" {
    default = "10.88.1.10"
}


variable "TRUST-IP" {
    default = "10.88.2.10"
}

