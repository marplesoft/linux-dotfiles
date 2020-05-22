set -e
set -x

pacman -Sy
pacman -S --noconfirm git
git clone https://github.com/marplesoft/linux-dotfiles.git
cd linux-dotfiles
./bootstrap.sh
