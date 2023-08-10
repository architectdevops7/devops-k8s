### Prometheus Operator to manage Prometheus and Grafana. First, install the Prometheus Operator:
```
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
```
