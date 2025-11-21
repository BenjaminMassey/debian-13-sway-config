#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root (use sudo)"
  exit 1
fi

read -p "This is intended as a setup script coming from a base Debian 13 install. Are you sure you know what you're doing? (y/n) " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  echo "Starting..."
else
  echo "Aborted."
  exit 1
fi

apt install -y sway alacritty fuzzel copyq brightnessctl tree-sitter-cli wget curl neowofetch obs-studio xdg-desktop-portal-wlr lxappearance wdisplays chromium waybar pkg-config

git config --global user.email "benjamin.w.massey@gmail.com"
git config --global user.name "Benjamin Massey"

sed -i '1i color_prompt=yes' ~/.bashrc

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer
cargo install cargo-deb

curl -LO --output-dir ~/Downloads https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
rm -rf /opt/nvim-linux-x86_64
tar -xzf ~/Downloads/nvim-linux-x86_64.tar.gz -C /opt
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >>~/.bashrc

wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Arimo.zip
cd ~/.local/share/fonts/
unzip *
rm ~/.local/share/fonts/Arimo.zip
fc-cache -fv

git clone https://www.github.com/LazyVim/starter ~/lazyvim-temp
cp -rn ~/lazyvim-temp/* ~/.config/nvim/
rm -rf ~/lazyvim-temp

mkdir ~/Development/
git clone https://github.com/YaLTeR/niri.git ~/Development/niri
cd ~/Development/niri
apt-get install -y gcc clang libudev-dev libgbm-dev libxkbcommon-dev libegl1-mesa-dev libwayland-dev libinput-dev libdbus-1-dev libsystemd-dev libseat-dev libpipewire-0.3-dev libpango1.0-dev libdisplay-info-dev
cargo install cargo-deb
cargo deb
dpkg -i ~/Development/niri/target/debian/*.deb
echo "alias nt='~/.config/niri/newterm.sh'" >>~/.bashrc

git clone https://github.com/Supreeeme/xwayland-satellite.git ~/Development/xwayland-satellite
cd ~/Development/xwayland-satellite/
apt install libxcb-cursor-dev
cargo build --release -F systemd
cp ~/systemd/user/xwayland-satellite.service /etc/systemd/user/
systemctl --user enable --now xwayland-satellite

echo "Done! Reboot and choose sway or niri."
