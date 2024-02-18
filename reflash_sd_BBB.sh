# Reflash SD card on Beagle Bone Black

# Export DISK
export DISK=/dev/sdb

# Clean data in SD card
echo "Clean data in SD card"
sudo dd if=/dev/zero of=${DISK} bs=1M count=10

# Go go u-boot folder
echo "Go to u-boot folder"
cd /home/ntai/Linux_Embedded/u-boot

# Install boot loader
echo "Install boot loader"
sudo dd if=./MLO of=${DISK} count=2 seek=1 bs=128k
sudo dd if=./u-boot-dtb.img of=${DISK} count=4 seek=1 bs=384k

sudo sfdisk --version

sudo sfdisk ${DISK} <<-__EOF__
4M,,L,*
__EOF__

sudo mkfs.ext4 -L rootfs -O ^metadata_csum,^64bit ${DISK}1

echo "Mount SD card to /media/rootfs"
sudo mkdir -p /media/rootfs/
sudo mount ${DISK}1 /media/rootfs/


echo "Backup bootloader"
sudo mkdir -p /media/rootfs/opt/backup/uboot/
sudo cp -v ./MLO /media/rootfs/opt/backup/uboot/
sudo cp -v ./u-boot-dtb.img /media/rootfs/opt/backup/uboot/


echo "Install kernel"
cd /home/ntai/Linux_Embedded/kernelbuildscripts

read -r kernel_version _ < <(cat kernel_version)
echo "Kernel version is $kernel_version"

cd /home/ntai/Linux_Embedded
echo "Copy root file system"
sudo tar xfvp ./debian-*-*-armhf-*/armhf-rootfs-*.tar -C /media/rootfs/
sync

cd /home/ntai/Linux_Embedded/kernelbuildscripts
echo "Setup uname_r in uboot.txt"
sudo sh -c "echo 'uname_r=${kernel_version}' >> /media/rootfs/boot/uEnv.txt"

echo "Copy kernel image"
sudo cp -v ./deploy/${kernel_version}.zImage /media/rootfs/boot/vmlinuz-${kernel_version}

echo "Copy device tree"
sudo mkdir -p /media/rootfs/boot/dtbs/${kernel_version}/
sudo tar xfv ./deploy/${kernel_version}-dtbs.tar.gz -C /media/rootfs/boot/dtbs/${kernel_version}/

echo "Copy kernel module"
sudo tar xfv ./deploy/${kernel_version}-modules.tar.gz -C /media/rootfs/

echo "Setup file system table"
sudo sh -c "echo '/dev/mmcblk0p1  /  auto  errors=remount-ro  0  1' >> /media/rootfs/etc/fstab"

echo "Install Network"
echo "auto lo
      iface lo inet loopback
    auto eth0
    iface eth0 inet static
	address 192.168.7.2
	netmask 255.255.255.0
	broadcast 192.168.7.255
	gateway 192.168.7.1"  >> /media/rootfs/etc/network/interfaces

echo "Remove SD card"
sync
sudo umount /media/rootfs

echo "Job done"






