# Create a Virtual Cloud Network (VCN)
resource "oci_core_vcn" "vcn" {
  compartment_id = var.tenancy_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "my-vcn"
  dns_label      = "myvcn"
}

# Create a subnet
resource "oci_core_subnet" "subnet" {
  compartment_id    = var.compartment_id
  vcn_id           = oci_core_vcn.vcn.id
  cidr_block       = "10.0.1.0/24"
  display_name     = "private-subnet"
  dns_label        = "privatesubnet"
  security_list_ids = [oci_core_security_list.security_list.id]
  route_table_id    = oci_core_route_table.route_table.id
}

# Create a security list
resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "security-list"

  # Allow outbound traffic
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Allow inbound SSH traffic (if needed)
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}

# Create a route table
resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "route-table"

  # Add route rules if needed
  # For example, for internet access:
  # route_rules {
  #   destination       = "0.0.0.0/0"
  #   network_entity_id = oci_core_internet_gateway.ig.id
  # }
}