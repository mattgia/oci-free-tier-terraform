terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0.0"
    }
  }
}

variable "tenancy_ocid" {}

provider "oci" {
  # Authentication details will be configured via environment variables or config file
  tenancy_ocid = var.tenancy_ocid  # This will be used as our root compartment
  # Other auth details from environment variables:
  # OCI_USER_OCID
  # OCI_FINGERPRINT
  # OCI_PRIVATE_KEY_PATH
  # OCI_REGION
}