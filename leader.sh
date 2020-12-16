#!/bin/bash

echo "\nDownloading docker..."
curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

echo "\nDownloading k3s..."
curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "\nCopying config..."
mkdir -p ~/.kube
sudo kubectl config view --raw > ~/.kube/config

echo "\nDownloading faas-cli..."
curl -sSL https://cli.openfaas.com | sudo sh

echo "\nDownloading arkade..."
curl -sLS https://dl.get-arkade.dev | sudo sh

echo "\nInstalling openfaas..."
sudo -E arkade install openfaas --load-balancer

echo "\nForwarding openfaas gateway..."
sudo kubectl rollout status -n openfaas deploy/gateway
sudo systemd-run --unit=faas.gateway kubectl port-forward -n openfaas svc/gateway 8080:8080

echo "\nLogin to faas-cli..."
export PASSWORD=$(sudo kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin

echo "Done."