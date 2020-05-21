set -e
set -x

# activate ntp to set correct time
timedatectl set-ntp true

DISK=/dev/sda
# remove all existing partitions
set +e
while parted -s $DISK rm 1; do :; done
set -e
parted -s $DISK mklabel gpt
parted -s $DISK mkpart ESP fat32 1MiB 513MiB
parted -s $DISK mkpart primary ext4 513MiB 100%
yes | mkfs.fat -F32 /dev/sda1
yes | mkfs.ext4 -F /dev/sda2

# optimize arch mirrors
pacman -Syy
pacman -S --noconfirm reflector
reflector -c Canada -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# bootstrap os
mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware vim netctl wpa_supplicant dchpcd dialog
genfstab -U /mnt >> /mnt/etc/fstab

# copy this git repo into the new disk
cp -r /root/linux-dotfiles /mnt/root/linux-dotfiles.sh

# chroot into the new install
arch-chroot /mnt
