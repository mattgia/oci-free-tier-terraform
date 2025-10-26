variable "compartment_id" {
  description = "OCID of the compartment where the instance will be created"
  type        = string
}

variable "availability_domain" {
  description = "The Availability Domain of the instance"
  type        = string
}

variable "subnet_id" {
  description = "The OCID of the subnet to create the VNIC in"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}