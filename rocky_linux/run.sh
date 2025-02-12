#!/bin/bash
set -e

# Refresh package metadata
sudo dnf makecache

# Enable the EPEL repository (often needed for extra packages on Rocky Linux)
sudo dnf install -y epel-release

sudo dnf install -y git vim wget net-tools curl

# Install Tilix (a tiling terminal emulator)
# Note: Tilix may not be packaged for Rocky Linux. If not, you may need to build it or find an alternative.
sudo dnf install -y tilix

# Install zsh
sudo dnf install -y zsh

# Install htop, nethogs, and tkdiff
sudo dnf install -y htop nethogs tkdiff

# Install ncdu (for directory usage analysis)
sudo dnf install -y ncdu
