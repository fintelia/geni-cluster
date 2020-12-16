#!/bin/bash

curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

curl -sfL https://get.k3s.io | K3S_URL=https://node0:6443 K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -
