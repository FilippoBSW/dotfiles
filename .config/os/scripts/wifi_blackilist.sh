#!/bin/sh

echo "blacklist ath12k" | sudo tee /etc/modprobe.d/ath12k.conf
sudo dracut --force --regenerate-all
