# Production-Ready Infrastructure Deployment


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


---

1. Docker
2. Kubernetes Cluster
3. GitHub Actions
4. Terraform
5. Bash Scripting