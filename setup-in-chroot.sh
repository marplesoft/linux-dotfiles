set -e
set -x

pacman -Syy

# clock setup
timedatectl set-timezone America/Vancouver
hwclock --systohc

# locale setup
sed -i "s/^#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# network setup
pacman -S --noconfirm netctl wpa_supplicant dhcpcd dialog
echo yoga > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 yoga
EOF

#setup bootloader
pacman -S --noconfirm grub efibootmgr
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet i915.edp_vswing=2"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

set +x
read -p "Root password:" ROOT_PWD 
echo root:$ROOT_PWD | chpasswd 

set -x
exit