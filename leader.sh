#!/bin/bash

curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -
sudo kubectl config view --raw | sudo tee ~/.kube/config

curl -sLS https://dl.get-arkade.dev | sudo sh

arkade install faas-cli
sudo -E arkade install openfaas