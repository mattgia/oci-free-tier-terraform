output "instance_public_ip" {
  description = "Public IP of the created instance"
  value       = oci_core_instance.free_instance.public_ip
}

output "instance_state" {
  description = "The state of the instance"
  value       = oci_core_instance.free_instance.state
}