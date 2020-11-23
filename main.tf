terraform {
  required_version = "0.13.5"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
  }
  backend "s3" {
    key                         = "github-demo-k8s.tfstate"
    bucket                      = "santiago-tf-state"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
