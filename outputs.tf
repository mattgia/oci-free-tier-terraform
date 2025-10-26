output "ssh_connection_command" {
  description = "Command to create SSH session through bastion"
  value       = "oci bastion session create --bastion-id ${oci_bastion_bastion.bastion.id} --target-private-ip ${oci_core_instance.free_instance.private_ip} --ssh-public-key-file <path_to_your_public_key>"
}