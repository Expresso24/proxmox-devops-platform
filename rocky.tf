resource "proxmox_virtual_environment_vm" "rocky_vm" {
  name          = "rocky-server"
  node_name     = "pve"
  vm_id         = 101
  scsi_hardware = "virtio-scsi-single"
  boot_order = ["scsi0"]

  # Auto-start VM on hypervisor reboot
  on_boot = true
  # Ensure the VM is running after deployment
  started = true

  protection = false

  hotplug = "disk,network,memory,cpu"

  cpu {
    cores = 2
    type  = "host"
    numa = true
  }

  memory {
    dedicated = 4096
  }

  stop_on_destroy  = true
  purge_on_destroy = true

  agent {
    enabled = true
  }

  # Disco del sistema operativo
  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/Rocky-Gold.img"
    interface    = "scsi0"
    size         = 30
    discard      = "on"
    ssd          = true
  }



  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Cloud-Init: Se crea y aprovisiona automáticamente desde este bloque
  initialization {
    datastore_id = "local-lvm" # Dónde se almacena el disco cloud-init generado

    ip_config {
      ipv4 {
        address = "192.168.1.160/24"
        gateway = "192.168.1.254"
      }
    }

    user_account {
      username = "rocky"
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAS24cXO6I2mQ6qpKW27l5cnC5j7vtODNpFSprdlu4h proxmox"
      ]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}