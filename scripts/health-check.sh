#!/bin/bash

set -e

# Check if Minikube is running
if ! minikube status | grep -q "Running"; then
  echo "❌ Error: Minikube is not running"
  echo "Starting minikube..."
  minikube start
fi

echo "🔍 Checking Deployments:"
kubectl get deployments -n production

echo ""
echo "🔍 Checking Pods:"
kubectl get pods -n production

echo ""
echo "🔍 Checking Ingress:"
kubectl get ingress -n production

echo ""
echo "✅ Health check complete!"
