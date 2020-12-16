
variable "shared_credentials_file" {
  description = "credentials fiel location"
  default = "~/.aws/credentials"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}

variable "first_cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.1.0/24"
}

variable "second_cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.2.0/24"
}

variable "morse_src_ami" {}

variable "az_a" {}

variable "az_b" {}

variable "elb_name" {}

variable "my_srvice_name" {
  description = "The DNS name for my service"
  default = "task.com"
}

variable "identifier" {}

variable "location" {}

variable "location_id" {}




