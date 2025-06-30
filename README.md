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
Made use of Multi stage build in my docker file that reduced my application size to 260MB. I prioritised the use of slim based images that are lightweight and run faster builds. Configured docker to run the container as `appuser` and not root, which is a best practice for security.

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
