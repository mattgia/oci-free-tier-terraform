variable "compartment_id" {
  description = "OCID of the compartment where the instance will be created"
  type        = string
}

variable "availability_domain" {
  description = "The Availability Domain of the instance"
  type        = string
}

# Removed subnet_id variable as we're creating the subnet in network.tf

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}