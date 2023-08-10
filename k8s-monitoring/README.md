### Install Prometheus and Grafana on Kubernetes
```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

### Step 1: Add repositories
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
```

### Step 2: Update Helm repositories
```
helm repo update
```

### Step 3: Install Prometheus Kubernetes 
```
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
```

### Step 4: Log in to Grafana
```
The default credentials for now:
username: admin
password: admin
```

### Overwrite the prometheus and grafana service
```
vi prometheus-service.yml 

apiVersion: v1
kind: Service
metadata:
  name: prometheus-kube-prometheus-prometheus
  namespace: default
  labels:
    app: prometheus
    instance: prometheus
    release: prometheus
spec:
  type: NodePort  # Change from ClusterIP to NodePort
  ports:
    - port: 9090
      targetPort: 9090
      name: web
  selector:
    app: prometheus
    release: prometheus
```

```
vi grafana-service.yml

apiVersion: v1
kind: Service
metadata:
  name: prometheus-grafana
  namespace: default
  labels:
    app: grafana
spec:
  type: NodePort  # Change from ClusterIP to NodePort
  ports:
    - port: 80
      targetPort: 3000  # Grafana port
  selector:
    app.kubernetes.io/instance: prometheus
    app.kubernetes.io/name: grafana
```
