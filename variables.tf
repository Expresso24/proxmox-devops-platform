variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_password" {
  type      = string
  sensitive = true
}

variable "proxmox_ssh_user" {
  type      = string
  sensitive = true
}

variable "bastion_password" {
  type        = string
  sensitive   = true
}