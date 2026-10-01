resource "proxmox_virtual_environment_vm" "arch_vm" {
  name          = "arch-server"
  node_name     = "pve"
  vm_id         = 103
  scsi_hardware = "virtio-scsi-pci"
  boot_order = ["scsi0"]

  protection = false

  hotplug = "disk,network,memory,cpu"

  cpu {
    cores = 2
    type  = "host"
    numa = true
  }

  memory {
    dedicated = 2048
  }

  stop_on_destroy  = true
  purge_on_destroy = true

  agent {
    enabled = false
  }

  # Disco del sistema operativo
  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/Arch-GenericCloud.img"
    interface    = "scsi0"
    size         = 41
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge = "vmbr1"
    model  = "virtio"
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "10.99.0.2/24"
        gateway = "10.99.0.1"
      }
    }

    user_account {
      username = "arch"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAS24cXO6I2mQ6qpKW27l5cnC5j7vtODNpFSprdlu4h proxmox"
      ]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}