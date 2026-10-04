resource "proxmox_virtual_environment_vm" "edge-proxy" {
    name = "edge-proxy"
    node_name = "pve"
    vm_id = 101
    scsi_hardware = "virtio-scsi-single"
    boot_order = ["scsi0"]

    # Auto-start VM on hypervisor reboot
    on_boot = true
    # Ensure the VM is running after deployment
    started = true

    #Avoid proxmox destruction
    protection = false

    cpu {
        cores = 1
        type = "host"
    }

  memory {
    dedicated = 1024
    floating  = 256
  }

    # Teardown behavior: Gracefully stop VM and purge all disk/storage remnants
    stop_on_destroy  = true
    purge_on_destroy = true

    # Enable QEMU guest agent for accurate metrics, IP reporting, and graceful shutdown
    agent {
        enabled = true
    }

  # Disco del sistema operativo
  disk {
    datastore_id = "local-lvm"
    file_id      = "local:iso/Alpine.img"
    interface    = "scsi0"
    size         = 2
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
        address = "192.168.1.164/24"
        gateway = "192.168.1.254"
      }
    }

    ip_config {
      ipv4 {
        address = "10.10.10.254/24"
      }
    }

    user_account {
        username = "edge"
        password = var.edge_password
        keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAS24cXO6I2mQ6qpKW27l5cnC5j7vtODNpFSprdlu4h proxmox"
        ]
    }

    }

    #avoid openotuf destroy vm
    lifecycle {
        prevent_destroy = false
    }
}