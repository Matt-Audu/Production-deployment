#!/bin/bash

set -e

# Check if Minikube is running
if ! minikube status | grep -q "Running"; then
  echo "❌ Error: Minikube is not running"
  echo "Starting minikube..."
  minikube start
fi

# Validate input: Deployment name
if [ -z "$1" ]; then
  echo "Usage: ./rollback.sh <deployment-name> [namespace]"
  exit 1
fi

DEPLOYMENT=$1
NAMESPACE=${2:-default}

echo "⏪ Rolling back deployment: $DEPLOYMENT in namespace: $NAMESPACE ..."

kubectl rollout undo deployment/"$DEPLOYMENT" -n "$NAMESPACE"

if [ $? -ne 0 ]; then
  echo "❌ Rollback failed!"
  exit 1
else
  echo "✅ Rollback successful!"
fi


