terraform {
  backend "s3" {
    bucket   = "terraform-state-storage"
    key      = "terraform.tfstate"
    region   = "ca-toronto-1"
    endpoints = {
      s3 = "https://namespace.compat.objectstorage.ca-toronto-1.oraclecloud.com"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 7.0.0"
    }
  }
}

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}