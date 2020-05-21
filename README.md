# Laptop Arch Initial Setup Instructions

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
    
Wait few seconds

    ping google.com

# Pull down this repo

    pacman -S git
    git clone https://github.com/marplesoft/linux-dotfiles
    
# Run the setup script

    cd linux-dotfiles
    ./initial-setup.sh

