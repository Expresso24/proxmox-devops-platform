terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.1.200:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
  ssh {
    agent    = false
    username = var.proxmox_ssh_user
    password = var.proxmox_ssh_password
    
    node {
      name    = "pve"
      address = "192.168.1.200"
    }
  }
}