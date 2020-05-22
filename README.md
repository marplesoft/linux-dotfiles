## Download Arch

Download the iso: https://www.archlinux.org/download/
    
Verify download signature:

    gpg --keyserver-options auto-key-retrieve --verify archlinux-.....iso.sig

## Write image to USB stick:

    dd ...
    
## Boot into the USB

Reboot holding Fn-F12
Switch to Arch Linux option

## Get internet

    rfkill unblock all
    wifi-menu
    
## Start script

    wget -q -O - https://raw.githubusercontent.com/marplesoft/linux-dotfiles/master/start.sh | bash

