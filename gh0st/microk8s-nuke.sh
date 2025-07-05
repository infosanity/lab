#!/usr/bin/bash

# Ensure root permissions - required for microk8s reset
if [ `whoami` != 'root' ]
  then
    echo "Root required for microk8s reset."
    exit
fi

echo "Reseting microk8s..."
microk8s reset

echo "Enableing Community Add-Ons..."
microk8s enable community

echo "Enabline Metrics Server..."
microk8s enable metrics-server
echo "Example: kubectl top node"