#!/bin/bash

curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -

curl -sLS https://dl.get-arkade.dev | sudo sh

arkade install faas-cli
arkade install openfaas