#!/bin/bash -i

set -e
set -x

# install yay for AUR and then install some AUR packages
git clone https://aur.archlinux.org/yay.git /tmp/yay
pushd /tmp/yay
makepkg -s --noconfirm
popd
gpg --recv-keys 8F173680 # needed for the following
yay -S --noconfirm obtheme

./link.sh