# Spice agent for Linux
# Install both qemu-guest-agent and spice-vdagent on each guest and reboot (the guests).
$ sudo apt install qemu-guest-agent
$ sudo apt install spice-vdagent


# Space Guest
  https://www.spice-space.org/download.html#guest
https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe

cd '/fast-storage-01/virtual-machines/Lab.com - Clients/Workstation'
sudo qemu-img convert -p -f qcow2 ./Workstation_E_Data.qcow2 -O qcow2 ./Workstation_E_Data-Shrinked.qcow2
sudo qemu-img convert -p -f qcow2 ./Workstation_H_Drive.qcow2 -O qcow2 ./Workstation_H_Drive-Shrinked.qcow2

# kvm Error starting domain: unsupported configuration: Unable to find security driver for model selinux
  # https://superuser.com/questions/1231348/kvm-error-starting-domain-unsupported-configuration-unable-to-find-security-dr
  # Solution -> https://superuser.com/a/1231349


# Qemu Disk Drivers for OS (virtio-win)
  # https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
  # 

# Extend Guest VM Disk
sudo qemu-img resize /study-zone/virtual-machines/SqlMonitor_E_Drive.qcow2 +100G

# Save VM Config for future Restore
virsh dumpxml vmname > vmname.xml

# Restore VM from Config file
/tmp/vmname.xml && virsh start myvm

