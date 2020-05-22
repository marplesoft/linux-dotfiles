#!/bin/bash

modprobe -r btusb
sleep 2
modprobe btusb
sleep 3
systemctl restart bluetooth.service