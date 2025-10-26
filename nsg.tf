
# Create a Network Security Group (NSG) for the compute instance
resource "oci_core_network_security_group" "instance_nsg" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "instance-nsg"
}

# Add a security rule to the instance NSG to allow all egress traffic
resource "oci_core_network_security_group_security_rule" "instance_nsg_egress" {
  network_security_group_id = oci_core_network_security_group.instance_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# Create a Network Security Group (NSG) for the bastion
resource "oci_core_network_security_group" "bastion_nsg" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "bastion-nsg"
}



# Add a security rule to the instance NSG to allow SSH traffic from the bastion
resource "oci_core_network_security_group_security_rule" "instance_nsg_ingress_from_bastion" {
  network_security_group_id = oci_core_network_security_group.instance_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_network_security_group.bastion_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Add a security rule to the bastion NSG to allow egress traffic to the instance
resource "oci_core_network_security_group_security_rule" "bastion_nsg_egress_to_instance" {
  network_security_group_id = oci_core_network_security_group.bastion_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  destination               = oci_core_network_security_group.instance_nsg.id
  destination_type          = "NETWORK_SECURITY_GROUP"
  
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

