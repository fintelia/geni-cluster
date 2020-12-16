#!/bin/bash

echo "\nDownloading docker..."
curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

echo "\nDownloading k3s..."
curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -

echo "\nDownloading faas-cli..."
curl -sSL https://cli.openfaas.com | sudo sh

echo "\nDownloading arkade..."
curl -sLS https://dl.get-arkade.dev | sudo sh

echo "\nCopying config..."
sudo kubectl config view --raw | sudo tee ~/.kube/config

echo "\nInstalling openfaas..."
sudo -E arkade install openfaas --load-balancer

echo "\nForwarding openfaas gateway..."
sudo kubectl rollout status -n openfaas deploy/gateway
sudo systemd-run kubectl port-forward -n openfaas svc/gateway 8080:8080

echo "\nLogin to faas-cli..."
export PASSWORD=$(sudo kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --pasword-stdin

echo "Done."