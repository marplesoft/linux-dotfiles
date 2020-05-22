set -e
set -x

# configure wifi
rfkill unblock all
cp home.netctl /etc/netctl/home
read -p "Wifi SSID: " SSID
read -p "Wifi Key: " SSIDKEY
sed -i "s/%SSID%/$SSID/" /etc/netctl/home
sed -i "s/%KEY%/$SSIDKEY/" /etc/netctl/home
netctl start home
netctl enable home
sleep 5

# setup reflector (again, now in the target disk)
pacman -S --noconfirm reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
reflector -c Canada -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# install some base stuff
pacman -S --noconfirm base-devel git vim

# bluetooth mouse
pacman -S --noconfirm bluez bluez-utils
cp blacklist_btusb.conf /etc/modprobe.d/
cp reload-btusb.sh /usr/bin/
cp reload-btusb.service /etc/systemd/system/
/usr/bin/reload-btusb.sh
sleep 5
systemctl enable reload-btusb.service
systemctl start bluetooth.service
systemctl enable bluetooth.service
sleep 5
MOUSE=34:88:5D:AD:1A:4D
bluetoothctl << EOF
power on
agent on
default-agent
trust $MOUSE
pair $MOUSE
connect $MOUSE
exit
EOF
sed -i "s/^#AutoEnable=false/AutoEnable=true/" /etc/bluetooth/main.conf

# setup users
sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers
useradd -m -G wheel ryan

# setup gui
pacman -S --noconfirm xorg
pacman -S --noconfirm openbox lightdm lightdm-gtk-greeter obconf pcmanfm tint2 termite nitrogen
systemctl enable lightdm.service

# touchpad and mouse tweaks
cp 99-synaptics-overrides.conf /etc/X11/xorg.conf.d/

# hidpi setup
sed -i "s/^#display-setup-script.*/display-setup-script=xrandr --output eDP-1 --scale 1.14x1.14/" /etc/lightdm/lightdm.conf
sed -i "s/#xft-dpi.*/xft-dpi=192/" /etc/lightdm/lightdm-gtk-greeter.conf
sed -i "s/^Exec=.*/Exec=env GDK_SCALE=2 GDK_DPI_SCALE=0.5 lightdm-gtk-greeter/" /usr/share/xgreeters/lightdm-gtk-greeter.desktop
cp hidpi.sh /etc/profile.d/
cp hidpi.sh /root/.Xsession
cp .Xresources /home/ryan/

set +x
echo "Reboot!"