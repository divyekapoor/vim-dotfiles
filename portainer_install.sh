#!/bin/bash
#
# Install Portainer on an Proxmox Virtual Container (LXC).
# Requires Privileged Container

sudo apt remove apparmor
sudo docker stop portainer
sudo docker rm portainer
sudo docker volume rm portainer_data
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ee:latest
