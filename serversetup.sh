#!/bin/bash

cd $HOME

# Install zsh, ufw, adduser
sudo apt update
DEBIAN_FRONTEND=noninteractive \
sudo apt install zsh-autosuggestions adduser ufw -qq -y

# Update configuartion zsh suggest completion
sudo sed -ie 's|history)|history completion match_prev_cmd)|' /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set default zshrc kali linux
curl -sL https://gitlab.com/kalilinux/packages/kali-defaults/-/raw/kali/master/etc/skel/.zshrc > .zshrc

# Add new user
while true; do
  echo -n "Input username: "
  read user_name
  if [[ $user_name =~ ^[[:alpha:]]+$ ]]; then
    sudo adduser $user_name --disabled-password --shell /bin/zsh
    sudo usermod -aG sudo $user_name
    sudo passwd --delete $user_name
    break
  else
    echo "Bad name, only alphabet allowed"
  fi
done

# Copy zshrc and ssh auth key into new user
sudo cp -r {.ssh,.zshrc} /home/$user_name
sudo chown -R $user_name /home/$user_name/{.ssh,.zshrc}

# Update new hostname server
sudo hostnamectl set-hostname "$user_name-node"
