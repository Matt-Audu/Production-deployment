# Production-Ready Service Deployment

---

This project sets up everything you need to run your application reliably in a production environment. It includes ready-made Kubernetes files, security settings, automation scripts, and monitoring tools to help you deploy, scale, and manage your app with confidence. Whether you’re testing locally on Minikube or rolling out to a real cluster, this setup gives you a solid starting point for modern DevOps and smooth operations.

Note: This project was carried out using a minikube cluster for testing purposes, minikube should never be used in a production environment.

```
.
├── README.md
├── RUNBOOK.md
├── backend
│   ├── Dockerfile
│   ├── main.py
│   ├── requirements.txt
│   └── test_main.py
├── k8s
│   ├── configmap.yml
│   ├── deployment.yml
│   ├── hpa.yml
│   ├── ingress.yml
│   ├── networkpolicy.yml
│   ├── secret.yml
│   ├── service.yml
│   └── serviceaccount.yml
├── monitoring
│   ├── alerts.yml
│   ├── grafana-dashboard.json
│   └── prometheus.yml
├── scripts
│   ├── deploy.sh
│   ├── health-check.sh
│   └── rollback.sh
├── security
│   ├── pod-security.yml
│   └── rbac.yml
└── terraform
    ├── main.tf
    ├── output.tf
    └── variable.tf
```

### Prerequisites

- - -


1. Docker
2. Kubernetes Cluster
3. GitHub Actions
4. Terraform
5. Bash Scripting

## Overview
This project involves containerizing a FastAPI backend service that is scalable and production ready. The application is configured to expose prometheus metrics for observability and monitoring. Built, tested and deployed using GitHub Actions.

### Multi Stage Build
Made use of Multi stage build in my docker file that reduced my application size to 260MB. I prioritised the use of slim base images that are lightweight and run faster builds. Configured docker to run the container as `appuser` and not root, which is a best practice for security.

```
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Final stage
FROM python:3.12-slim

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### GitHub Actions Workflow
+ [Continuous Integration:](https://github.com/Matt-Audu/Production-deployment/blob/main/.github/workflows/integration.yml) 
  1.  I configured my workflow to run a pytest for testing API endpoints "GET`/items`" "GET`/health`" and "POST`/items`" and it automatically fails the workflow if any test is not successful. 
  2. Integrated docker trivy scanner to scan my dockerfile and docker images. The workflow fails if vulnerabilities are detected in my dockerfile and docker images. This will minimize production issues and improve security. 
  3. My integration pipeline is triggered by a pull request to the main branch, in this case all application test are performed before merging into "main" branch for deployment.

+ [Continuous Deployment:](https://github.com/Matt-Audu/Production-deployment/blob/main/.github/workflows/deploy.yml) 
  1. After my image has been scanned successfully with no vulnerabilities, my deployment workflow is set up to build and tag my docker images. 
  2. I configured a versioning system to tag my images using the traditional versioning pattern i.e "v1.0.1" which helps to track various images properly for best practice.
  3. Once the image has been tagged, my workflow pushes my image to dockerhub remote repository. 
  4. Because I decided to use a Minikube cluster, my workflow will SSH into my minikube server and run my deployment script to deploy the backend service in my kubernetes cluster.


### Kubernetes Manifests

- **`configmap.yml`**: Stores general configuration settings for my application(like environment name or feature flags) so I don’t have to hard-code them.

- **`deployment.yml`**: Defines *how* my app should run on Kubernetes, how many copies (pods) to run, which Docker image to use, and basic health checks.

- **`hpa.yml`**: The Horizontal Pod Autoscaler automatically adds or removes pods based on CPU or memory usage, so my app can handle more traffic when needed.

- **`ingress.yml`**: Manages external access to my app (like routing traffic from your domain name to the right service) and handles things like SSL and CORS rules. Ingress also works like a load balancer for my application.

- **`networkpolicy.yml`**: Controls what network traffic is allowed to reach my pods, adding an extra layer of security.

- **`secret.yml`**: Stores sensitive data e.g Docker Hub username and password that my application needs but shouldn’t be hard-coded or visible in plain text.

- **`service.yml`**: Creates a stable internal IP and DNS name for backend service so other services or users can reach it reliably inside the cluster.

- **`serviceaccount.yml`**: Gives my backend app permissions to interact with the Kubernetes API securely, using only the access it needs.

- **`pod-security.yml`**: Defines rules that control what my pods are allowed to do (for example, restricting running as root), helping keep your cluster safer.

- **`rbac.yml`**: Sets up Role-Based Access Control (RBAC) to manage who (or what) can access specific Kubernetes resources, ensuring only the right accounts have permission.

### Monitoring

I implemented the use of prometheus and Grafana to monitor and visualize metrics from my backend service. Although the full configuration is not here just to maintain project demands. If you want to get a view of the whole configuration click [here](https://github.com/Matt-Audu/Observability-Stack).

A quick look at what each monitoring file does:

- **`alerts.yml`**: Defines alert rules for Prometheus so you get notified when something goes wrong or crosses a threshold (like high CPU or memory usage).

- **`grafana-dashboard.json`**: A pre-made dashboard configuration for Grafana to visualize my backend service key metrics in a clear, beautiful way. This was downloaded from Grafana Labs.

- **`prometheus.yml`**: The main configuration for Prometheus that tells it **what to monitor**, **where to scrape metrics from**, and **how often to check**. For this project, it scrapes only my backend service for metrics.

![Grafana Dashboard](https://drive.google.com/uc?export=view&id=15OBJOqmjIPFiCu4RUxojOjVyaT8rtzQ3)

### Automation Scripts

I authored wrapper scripts for automating kubernetes deployment for all my kubernetes manifests ehich makes it easier and faster to deploy. Also wrote rollback scripts to handle failed deployments and reduce downtime. Implemented a production based design to handle downtime, deployment and health check.

A quick look at what each script does:

- **`deploy.sh`**: Runs all the steps needed to deploy my backend service app and Kubernetes resources to the cluster in one go.

- **`health-check.sh`**: Checks if my app and pods are healthy and running as expected, so I know everything is working fine.

- **`rollback.sh`**: If something goes wrong, this script lets you roll back your deployment to the previous stable version easily. By running `./rollback.sh <deployment name>` , my app rolls back to previous working version.



