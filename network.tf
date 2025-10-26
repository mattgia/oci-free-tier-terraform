# Create a Virtual Cloud Network (VCN)
resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "my-vcn"
  dns_label      = "myvcn"
}

# Create a subnet
resource "oci_core_subnet" "subnet" {
  compartment_id    = var.tenancy_ocid
  vcn_id           = oci_core_vcn.vcn.id
  cidr_block       = "10.0.1.0/24"
  display_name     = "private-subnet"
  dns_label        = "privatesubnet"
  route_table_id    = oci_core_route_table.private_route_table.id
}

# Create a route table for the private subnet
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "private-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

# Create a NAT Gateway
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "nat-gateway"
}