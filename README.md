
```
.
├── README.md
├── RUNBOOK.md
├── [backend](https://github.com/Matt-Audu/Production-deployment/tree/main/backend)
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