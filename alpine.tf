resource "proxmox_virtual_environment_vm" "alpine_vm" {
  name          = "alpine-server"
  node_name     = "pve"
  vm_id         = 104
  scsi_hardware = "virtio-scsi-pci"
  boot_order = ["scsi0"]

  protection = false

  hotplug = "disk,network,memory,cpu"

  cpu {
    cores = 1
    type  = "host"
    numa = true
  }

  memory {
    dedicated = 1024
  }

  stop_on_destroy  = true
  purge_on_destroy = true

  agent {
    enabled = false
  }

  # Disco del sistema operativo
  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/Alpine-GenericCloud.img"
    interface    = "scsi0"
    size         = 5
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  network_device {
    bridge = "vmbr1"
    model  = "virtio"
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "192.168.1.163/24"
        gateway = "192.168.1.254"
      }
    }

    #for blackarch
    ip_config {
      ipv4 {
        address = "10.99.0.1/24"
      }
    }

    user_account {
      username = "alpine"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAS24cXO6I2mQ6qpKW27l5cnC5j7vtODNpFSprdlu4h proxmox"
      ]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}