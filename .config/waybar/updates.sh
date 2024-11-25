#!/bin/bash
# Script to update system and AUR

# Update system packages with pacman
sudo pacman -Syu

# Upgrade AUR packages with yay
yay -Syu
