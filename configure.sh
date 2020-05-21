set -e
set -x

# setup reflector (again, now in the target disk)
pacman -S --nconfirm reflector
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
reflector -c Canada -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# install some stuff
pacman -S --noconfirm base-devel git

# # bluetooth mouse
# pacman -S --noconfirm bluez bluez-utils
# cp blacklist_btusb.conf /etc/modprobe.d/
# cp reload-btusb.service /etc/systemd/system/
# systemctl enable reload-btusb.service
# systemctl start bluetooth.service
# systemctl enable bluetooth.service
# bluetoothctl << EOF

# agent on
# default-agent
# scan on
# trust XX:XX
# pair XX:XX
# connect XX:XX
# edit /etc/bluetooth/main.conf
# Add under [Policy]:
# AutoEnable=true
# EOF
# # setup users
# useradd -m -G wheel ryan

# # touchpad and mouse tweaks
# cp 99-synaptics-overrides.conf /etc/X11/xorg.conf.d/

# #desktop setup
# pacman -S xorg openbox lightdm lightdm-gtk-greeter

# # hidpi setup
# sed -i "s/^#display-setup-script.*/display-setup-script=xrandr --output eDP-1 --scale 1.14x1.14/" /etc/lightdm/lightdm.conf
# sed -i "s/#xft-dpi.*/xft-dpi=192/" /etc/lightdm/lightdm-gtk-greeter.conf
# sed -i "s/^Exec=.*/Exec=env GDK_SCALE=2 GDK_DPI_SCALE=0.5 lightdm-gtk-greeter/" /usr/share/xgreeters/lightdm-gtk-greeter.desktop
# cp hidpi.sh /etc/profile.d/
# cp hidpi.sh /root/.Xsession
# cp .Xresources /home/ryan/
