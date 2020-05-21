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

echo "Set a root password now with passwd..."
