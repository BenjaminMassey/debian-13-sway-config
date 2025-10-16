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

apt install sway alacritty fuzzel copyq brightnessctl tree-sitter-cli wget curl neowofetch obs-studio xdg-desktop-portal-wlr lxappearance wdisplays

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

wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Arimo.zip &&
  cd ~/.local/share/fonts &&
  unzip Arimo.zip &&
  rm Arimo.zip &&
  fc-cache -fv

git clone https://www.github.com/LazyVim/starter ~/lazyvim-temp
cp -rn ~/lazyvim-temp/* ~/.config/nvim/
rm -rf ~/lazyvim-temp

echo "Done! Reboot and choose sway."
