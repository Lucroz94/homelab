# installing libguestfs-tools only required once, prior to first run
sudo apt update -y
sudo apt install libguestfs-tools -y

# remove existing image in case last execution did not complete successfully
rm debian-11-genericcloud-amd64.qcow2
wget https://cdimage.debian.org/cdimage/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2
sudo virt-customize -a debian-11-genericcloud-amd64.qcow2 --install qemu-guest-agent
sudo qm create 9000 --name "your_template_vm_name" --memory 1024 --cores 1 --net0 virtio,bridge=vmbr0
sudo qm importdisk 9000 debian-11-genericcloud-amd64.qcow2 local-lvm
sudo qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
sudo qm set 9000 --boot c --bootdisk scsi0
sudo qm set 9000 --ide2 local-lvm:cloudinit
sudo qm set 9000 --serial0 socket --vga serial0
sudo qm set 9000 --agent enabled=1
sudo qm template 9000
rm debian-11-genericcloud-amd64.qcow2
echo "next up, clone VM, then expand the disk"
echo "you also still need to copy ssh keys to the newly cloned VM"