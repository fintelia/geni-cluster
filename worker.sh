#!/bin/bash

curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

curl -sfL https://get.k3s.io | K3S_URL=node0 K3S_TOKEN=my_super_secret_token sudo sh -
