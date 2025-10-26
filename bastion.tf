# Create a bastion service
resource "oci_bastion_bastion" "bastion" {
  bastion_type                 = "STANDARD"
  compartment_id               = var.tenancy_ocid
  target_subnet_id             = oci_core_subnet.subnet.id
  name                         = "private-subnet-bastion"
  client_cidr_block_allow_list = ["0.0.0.0/0"]  # WARNING: This is not secure. Please restrict this to your IP address.
}