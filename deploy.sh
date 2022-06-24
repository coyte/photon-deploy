### This script prepares a deployed photon os for use
### Sets IP addres, hostname and password
### Update packages
### Configures sshd
### Installs rclone

### Usage:
### Source the edited env-vars.sh
### Run from the console in the hypervisor (proxmox, esxi, ...) 
### curl -s <script URL> | bash


#!/bin/bash

#Set IP address
rm -f /etc/systemd/network/* #delete existing network config

cat > /etc/systemd/network/static.network << EOF
[Match]
Name=eth0
[Network]
Domains=$FQDN
Address=$IPADDR
Gateway=$GATEWAY
DNS=$DNS
EOF

systemctl restart systemd-networkd


#Set hostname
hostnamectl set-hostname ${FQDN%%.*}

# Add alias
cat > /etc/profile.d/alias.sh << EOF
#!/bin/bash
alias ll='ls -al'
EOF

#Enable ssh root login
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
systemctl restart sshd

#Update packages
tdnf update
tdnf -y install 

#Add rclone for public storage mount
curl -s https://rclone.org/install.sh | sudo bash

