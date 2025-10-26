terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0.0"
    }
  }
}

provider "oci" {
  # Authentication details will be configured via environment variables or config file
  # OCI_TENANCY_OCID
  # OCI_USER_OCID
  # OCI_FINGERPRINT
  # OCI_PRIVATE_KEY_PATH
  # OCI_REGION
}