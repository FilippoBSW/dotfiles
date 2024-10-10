#!/bin/sh

sudo groupadd --system i2c
sudo usermod "$1" -aG i2c
