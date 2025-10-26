# We'll use the tenancy OCID as the root compartment ID, which is provided via the OCI_TENANCY_OCID environment variable

# Removed availability_domain variable as we're using data source

# Removed subnet_id variable as we're creating the subnet in network.tf

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}