resource "proxmox_virtual_environment_vm" "debian_vm" {
  name          = "debian-server"
  node_name     = "pve"
  vm_id         = 102
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
    dedicated = 6144
  }

  stop_on_destroy  = true
  purge_on_destroy = true

  agent {
    enabled = true
  }

  # Disco del sistema operativo
  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/Debian-13-GenericCloud.img"
    interface    = "scsi0"
    size         = 80
    discard      = "on"
    ssd          = true
  }

  # disk {
  #   file_id   = "/dev/disk/by-id/ata-ADATA_SU650_4N3523B0C6XV"
  #   interface = "scsi1"
  #   discard   = "on"
  #   ssd       = true
  #   backup    = false
  # }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "192.168.1.161/24"
        gateway = "192.168.1.254"
      }
    }

    user_account {
      username = "debian"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAS24cXO6I2mQ6qpKW27l5cnC5j7vtODNpFSprdlu4h proxmox"
      ]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}