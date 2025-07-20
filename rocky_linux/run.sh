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

## Insatlling flatc/flatbuffers
# wget https://github.com/google/flatbuffers/archive/refs/tags/v25.2.10.tar.gz 
# tar -xvzf v25.2.10.tar.gz
# cd flatbuffers-25.2.10
# cmake -G "Unix Makefiles"
# make -j