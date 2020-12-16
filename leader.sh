#!/bin/bash

echo "Downloading docker..."
curl -fsSL https://get.docker.com | sudo sh -
sudo usermod -aG docker $USER

echo ""
echo "Downloading k3s..."
curl -sfL https://get.k3s.io | K3S_CLUSTER_SECRET=my_super_secret_token sudo sh -

echo ""
echo "Copying config to $HOME/.kube/config..."
mkdir -p $HOME/.kube
sudo kubectl config view --raw > $HOME/.kube/config

echo ""
echo "Downloading faas-cli..."
curl -sSL https://cli.openfaas.com | sudo sh

echo ""
echo "Downloading arkade..."
curl -sLS https://dl.get-arkade.dev | sudo sh

echo ""
echo "Installing openfaas..."
sudo -E arkade install openfaas --load-balancer

echo ""
echo "Forwarding openfaas gateway..."
sudo kubectl rollout status -n openfaas deploy/gateway
sudo systemd-run --unit=faas.gateway kubectl port-forward -n openfaas svc/gateway 8080:8080

echo ""
echo "Login to faas-cli..."
export PASSWORD=$(sudo kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
echo -n $PASSWORD | faas-cli login --username admin --password-stdin

echo "Done."