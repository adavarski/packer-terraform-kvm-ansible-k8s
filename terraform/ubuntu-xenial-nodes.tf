################################
# Auto-Cloud Terraform Builder #
################################
# Libvirt provider #
##################################
# Ubuntu 16.04 from Packer Build #
##################################

provider "libvirt" { uri = "qemu:///system" }

resource "libvirt_volume" "ubuntu-disk" {
  count = 3 
  name = "ubuntu00${count.index}.qcow2"
  source = "../packer/ubuntu-xenial-base/ubuntu-xenial-base.qcow2"
}

resource "libvirt_domain" "k8s" {
  count = 3 
  name = "ubuntu00${count.index}"
  memory = "1024"
  vcpu = 1

  disk { volume_id = "${element(libvirt_volume.ubuntu-disk.*.id, count.index)}" }

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
