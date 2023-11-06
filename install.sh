#!/bin/bash

# Apt update
apt -y update && apt -y dist-upgrade && apt full-upgrade -y && apt -y autoremove

apt install -y \
        kali-linux-core \
        nmap \
        iputils-ping \
        openvpn \
        sliver \
	net-tools \
	vim \
	nano

apt clean && rm -rf /var/lib/apt/lists/*
