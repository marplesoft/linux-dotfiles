# activate ntp to set correct time
timedatectl set-ntp true

# setup disk partitions
fdisk /dev/sda
d to delete partions
n
 +512M
t 1
n *
t 20
w
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# optimize arch mirrors
pacman -Syy
pacman -S reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
reflector -c Canada -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# bootstrap os
mount /dev/sda2 /mnt
pacstrap /mnt base linux linux-firmware vim netctl wpa_supplicant dchpcd dialog
genfstab -U /mnt >> /mnt/etc/fstab

# chroot into the new install
# below this we're affecting the new install
arch-chroot /mnt

# clock setup
timedatectl set-timezone America/Vancouver
hwclock --systohc

# locale setup
vim /etc/locale.gen
uncomment en_US.UTF-8 UTF-8
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# network setup
echo yoga > /etc/hostname
vim /etc/hosts
 127.0.0.1 localhost
 ::1 localhost
 127.0.1.1 yoga

# bluetooth mouse
cp blacklist_btusb.conf /etc/modprobe.d/
cp reload-btusb.service /etc/systemd/system/
systemctl enable reload-btusb.service
pacman -S bluez bluez-utils
systemctl enable bluetooth.service
bluetoothctl
agent on
default-agent
scan on
trust XX:XX
pair XX:XX
connect XX:XX
edit /etc/bluetooth/main.conf
Add under [Policy]:
AutoEnable=true

# setup users
useradd -m -G wheel ryan

# touchpad and mouse tweaks
cp 99-synaptics-overrides.conf /etc/X11/xorg.conf.d/

#desktop setup
pacman -S xorg openbox lightdm lightdm-gtk-greeter

# hidpi setup
sed -i "s/^#display-setup-script.*/display-setup-script=xrandr --output eDP-1 --scale 1.14x1.14/" /etc/lightdm/lightdm.conf
sed -i "s/#xft-dpi.*/xft-dpi=192/" /etc/lightdm/lightdm-gtk-greeter.conf
sed -i "s/^Exec=.*/Exec=env GDK_SCALE=2 GDK_DPI_SCALE=0.5 lightdm-gtk-greeter/" /usr/share/xgreeters/lightdm-gtk-greeter.desktop
cp hidpi.sh /etc/profile.d/
cp hidpi.sh /root/.Xsession
cp .Xresources /home/ryan/
