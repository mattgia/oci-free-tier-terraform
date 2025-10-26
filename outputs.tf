output "instance_public_ip" {
  description = "Public IP of the created instance"
  value       = oci_core_instance.free_instance.public_ip
}

output "instance_state" {
  description = "The state of the instance"
  value       = oci_core_instance.free_instance.state
}

output "instance_private_ip" {
  description = "Private IP of the created instance"
  value       = oci_core_instance.free_instance.private_ip
}

output "bastion_id" {
  description = "OCID of the bastion service"
  value       = oci_bastion_bastion.bastion.id
}

output "ssh_connection_command" {
  description = "Command to create SSH session through bastion"
  value       = "Use the OCI Console to create a bastion session, then use the provided SSH command"
}