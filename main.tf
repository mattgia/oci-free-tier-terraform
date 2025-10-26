# Get the latest Oracle Linux 8 image
data "oci_core_images" "os_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.A1.Flex"  # Free tier eligible shape
  sort_by                 = "TIMECREATED"
  sort_order              = "DESC"
}

# Create compute instance
resource "oci_core_instance" "free_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "free-tier-instance"
  
  shape = "VM.Standard.A1.Flex"
  
  shape_config {
    memory_in_gbs = 24  # Free tier eligible: up to 24GB
    ocpus         = 4   # Free tier eligible: up to 4 OCPUs
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os_images.images[0].id
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = false  # Disabled public IP assignment
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

# Create a 100GB block volume
resource "oci_core_volume" "persistent_volume" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "persistent-storage"
  size_in_gbs        = 100
}

# Attach the block volume to the instance
resource "oci_core_volume_attachment" "persistent_volume_attachment" {
  attachment_type = "paravirtualized"  # Recommended for Linux instances
  instance_id     = oci_core_instance.free_instance.id
  volume_id       = oci_core_volume.persistent_volume.id
}