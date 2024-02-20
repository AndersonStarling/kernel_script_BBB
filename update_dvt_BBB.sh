echo "Building device tree"
cd /home/ntai/Linux_Embedded/kernelbuildscripts/KERNEL
make -j2 ARCH=arm LOCALVERSION=-bone66 CROSS_COMPILE="/home/ntai/Linux_Embedded/kernelbuildscripts/dl/gcc-8.5.0-nolibc/arm-linux-gnueabi/bin/arm-linux-gnueabi-" dtbs
echo "Finnish the job"

echo "Updating dtb file to BBB"
scp /home/ntai/Linux_Embedded/kernelbuildscripts/KERNEL/arch/arm/boot/dts/am335x-boneblack.dtb debian@192.168.7.2:/boot/dtbs/5.4.242-bone66
echo "Finnish the job"
