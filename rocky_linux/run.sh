#!/bin/bash
set -e

# Update
sudo dnf update -y

# Refresh package metadata
sudo dnf makecache

# Enable the EPEL repository (often needed for extra packages on Rocky Linux)
sudo dnf install -y epel-release

##
sudo dnf reinstall openldap openldap-devel

sudo dnf install -y git vim wget net-tools curl  postgresql-devel tmux lsof htop
# Install Tilix (a tiling terminal emulator)
# Note: Tilix may not be packaged for Rocky Linux. If not, you may need to build it or find an alternative.
sudo dnf install -y tilix

# Install zsh
sudo dnf install -y zsh

# Install htop, nethogs, and tkdiff
sudo dnf install -y htop nethogs tkdiff

# Install ncdu (for directory usage analysis)
sudo dnf install -y ncdu

# Install gcc
sudo dnf install -y gcc gcc-c++

# Install stunnel
sudo yum install -y stunnel

# Install redis and update the settings as well
sudo dnf install -y redis
## Ensure `daemonize` yes
sudo sed -i 's/^#\?\s*daemonize\s\+.*/daemonize yes/' /etc/redis/redis.conf

sudo systemctl enable redis
sudo systemctl start redis

## Install supervisord
sudo yum -y install supervisor
sudo systemctl enable supervisord
sudo systemctl start supervisord

## Installing cmake
sudo dnf install -y cmake

## Setting `DefaultLimitNOFILE` across all the processs
sudo sed -i '/^DefaultLimitNOFILE/d' /etc/systemd/system.conf
echo 'DefaultLimitNOFILE=10000' | sudo tee -a /etc/systemd/system.conf

# User sessions managed by systemd --user
sudo sed -i '/^DefaultLimitNOFILE/d' /etc/systemd/user.conf
echo 'DefaultLimitNOFILE=10000' | sudo tee -a /etc/systemd/user.conf

##
# Ensure vm.max_map_count is set
sudo sed -i '/^vm.max_map_count=/d' /etc/sysctl.conf
sudo sed -i '/^fs.file-max=/d' /etc/sysctl.conf
echo 'vm.max_map_count=1048576' | sudo tee -a /etc/sysctl.conf >/dev/null
echo 'fs.file-max=1048576' | sudo tee -a /etc/sysctl.conf >/dev/null

# Reload sysctl settings
sudo sysctl -p

# Apply
sudo systemctl daemon-reload


# Checks for Desired values
VM_EXPECTED=1048576
FS_EXPECTED=1048576

# Read current values
VM_CURRENT=$(sysctl -n vm.max_map_count 2>/dev/null)
FS_CURRENT=$(sysctl -n fs.file-max 2>/dev/null)

# Check vm.max_map_count
if [[ "$VM_CURRENT" -eq "$VM_EXPECTED" ]]; then
    echo "✅ vm.max_map_count is correctly set to $VM_CURRENT"
else
    echo "❌ vm.max_map_count is $VM_CURRENT (expected $VM_EXPECTED)"
fi

# Check fs.file-max
if [[ "$FS_CURRENT" -eq "$FS_EXPECTED" ]]; then
    echo "✅ fs.file-max is correctly set to $FS_CURRENT"
else
    echo "❌ fs.file-max is $FS_CURRENT (expected $FS_EXPECTED)"
fi

## Insatlling flatc/flatbuffers
# wget https://github.com/google/flatbuffers/archive/refs/tags/v25.2.10.tar.gz 
# tar -xvzf v25.2.10.tar.gz
# cd flatbuffers-25.2.10
# cmake -G "Unix Makefiles"
# make -j