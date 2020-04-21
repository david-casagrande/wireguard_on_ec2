#!/bin/bash

# Install Wireguard
apt install software-properties-common -y
add-apt-repository ppa:wireguard/wireguard -y
apt update
apt install wireguard -y

# Enable IP forwarding
NET_FORWARD="net.ipv4.ip_forward=1"
sysctl -w  ${NET_FORWARD}
sed -i "s:#${NET_FORWARD}:${NET_FORWARD}:" /etc/sysctl.conf
