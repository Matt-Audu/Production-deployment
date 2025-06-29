#!/bin/bash

set -e

k8s_dir="./k8s"
k8s_security="./security"

# Check if Minikube is running
if ! minikube status | grep -q "Running"; then
  echo "❌ Error: Minikube is not running"
  echo "Starting minikube..."
  minikube start
fi



#Deploy Kubernetes YAML files
cd "$k8s_dir"
kubectl apply -f serviceaccount.yml
kubectl apply -f secret.yml
kubectl apply -f configmap.yml
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f ingress.yml
kubectl apply -f hpa.yml
kubectl apply -f networkpolicy.yml
cd ..
cd "$k8s_security"
kubectl apply -f rbac.yml
kubectl apply -f pod-security.yml
cd ..
echo "✅ Deployment complete!"

#check status
kubectl rollout status deployment/backend-deployment -n production
if [ $? -eq 0 ]; then
  echo "✅ Deployment is successful!"
else
  echo "❌ Deployment failed!"
  exit 1
fi
  
